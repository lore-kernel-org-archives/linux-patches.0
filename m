Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F894657CF;
	Tue, 16 Jun 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625463; cv=none; b=ukj+iZQ7nxYRi3sIPYs3PLwTf/Di6gb1Xbo3DWk6X+L3OD/CYIdZN2ut1QiagBtl0SSbnq6ZKAtGBQl7gYuX+ryyb9XOFrNTjjP6/tbHVTlMUo8a06S7u6SLhA/Gem/IooBtplEaZau82gpu5asoOWcz/YEyioPbqj7jMcWG8Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625463; c=relaxed/simple;
	bh=Zp1Etvp3Jzn0crWdVoLBZg+ZC7eDMMQJC2OXeYS03PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyWwp+hOQ3mONVXTWCDmoq6gk2H802XAwhf9XziBgMFuLPHKnzxxlW6oFii0L/Dqzn3Q0QKEXIdDkKkujc0C9R5Ef1jBxDbEs02PZyHhBLOSVC7xvLuELac/ztkq6wsMgmNjDYXRUQQw9BDCdLc9abtt98rs5XeOT4iTOjXIETA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qf+b1sr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qf+b1sr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DBF1F00A3D;
	Tue, 16 Jun 2026 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625462;
	bh=QJ7RSujnJkIqaUQG9kNZUOPtXmix6uMYGopnAqzsmZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qf+b1sr/hHaf3+kD9S4d/7HgCWTQFNlYcR7vfQKsyvwItvnmT7SDsHr/wGKK2841S
	 dCwBGjmAkcopjeZktLPvq4xAgF6fIpBKHURl8XqkajXvwzKhBOiOWYzhn2rBYGo/rB
	 zjxPByzaSwBnMPL2PSYzG5KvrUufTyUc9yiBbFQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/325] accel/amdxdna: Fix mm_struct reference leak in aie2_populate_range()
Date: Tue, 16 Jun 2026 20:29:02 +0530
Message-ID: <20260616145105.001175206@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 2f41af638c92bac6f1f9275ea2d1901baef578f3 ]

aie2_populate_range() jumps back to the again label without calling
mmput(mm), leaking a reference to the mm_struct.

Add the missing mmput() before jumping to again.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260610151127.2994185-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 4610f491f0881c..80de2906a26fcb 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -828,6 +828,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 
 		if (ret == -EBUSY) {
 			amdxdna_umap_put(mapp);
+			mmput(mm);
 			goto again;
 		}
 
@@ -838,11 +839,13 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	if (mmu_interval_read_retry(&mapp->notifier, mapp->range.notifier_seq)) {
 		up_write(&xdna->notifier_lock);
 		amdxdna_umap_put(mapp);
+		mmput(mm);
 		goto again;
 	}
 	mapp->invalid = false;
 	up_write(&xdna->notifier_lock);
 	amdxdna_umap_put(mapp);
+	mmput(mm);
 	goto again;
 
 put_mm:
-- 
2.53.0



