Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3E23218D6;
	Mon, 18 Aug 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522444; cv=none; b=YcHFCNX+hFPzxPvC5rhv4SgpDqzxE8hbIlkjzuyG1kWk24S8VzR2IAQk58lx/Tc1hUsY4DS9uZLg+16spFnGPX4XkOeVjvwXnSciNm6MRT6HgQcDFNVR/mqNcXe+V1rYl8NN49c33CtrTKKciiqhmb6pleb8jHEtHyKak1qZBlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522444; c=relaxed/simple;
	bh=ELo4dE+lvwbw6+PkJRUyOKtt569e4EM2Dw1jXGfC+CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhYMSQhJ+SIS2wkVo3sj7LBlKX4l2PGm8fW4tsEQKPh8OBjFRwwswfctkWkz2OjlAEd94ZV1de5ADgIQq+v3aIEva5iw8bHYdqRrU94WPvLoo+g/Cc4PHJzl30mXJ9o+42hYuYJPDEUYfrOWKkg5mY0EZln64qHp9zcRl9pAhA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OK2vD+gW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OK2vD+gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87298C4CEEB;
	Mon, 18 Aug 2025 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522444;
	bh=ELo4dE+lvwbw6+PkJRUyOKtt569e4EM2Dw1jXGfC+CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OK2vD+gWpUXqRZ6ufZ2UCh/5Xz7SLKzFUfMrkrybb9PMj4zU3ERqZBdBXYNLDHiN2
	 jvnYrLU6a0gaYj8+0UhC1cZA9SGVNxG0taenBuNeGgYVqTOABD5uWdsER8rDClADh+
	 rJMn9l63H2pWMDmFaCtUKTGyvJbXn61aB8g7GCMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jackysliu <1972843537@qq.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/444] scsi: bfa: Double-free fix
Date: Mon, 18 Aug 2025 14:45:17 +0200
Message-ID: <20250818124459.869755223@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: jackysliu <1972843537@qq.com>

[ Upstream commit add4c4850363d7c1b72e8fce9ccb21fdd2cf5dc9 ]

When the bfad_im_probe() function fails during initialization, the memory
pointed to by bfad->im is freed without setting bfad->im to NULL.

Subsequently, during driver uninstallation, when the state machine enters
the bfad_sm_stopping state and calls the bfad_im_probe_undo() function,
it attempts to free the memory pointed to by bfad->im again, thereby
triggering a double-free vulnerability.

Set bfad->im to NULL if probing fails.

Signed-off-by: jackysliu <1972843537@qq.com>
Link: https://lore.kernel.org/r/tencent_3BB950D6D2D470976F55FC879206DE0B9A09@qq.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad_im.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 66fb701401de..0cc04c84b259 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -706,6 +706,7 @@ bfad_im_probe(struct bfad_s *bfad)
 
 	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
+		bfad->im = NULL;
 		return BFA_STATUS_FAILED;
 	}
 
-- 
2.39.5



