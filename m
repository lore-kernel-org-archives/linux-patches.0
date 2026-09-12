Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5103909A5;
	Sat, 12 Sep 2026 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243093; cv=none; b=J6/TCYYRP3WIlHvQ9l8HQjXm/7fYgJs2xe5qHWV/2H1JUQY3gpEQExTILqxONGEHUVq6aKJ2c7AhzhjiYMn8qFMcpAu7trJ4ELwdNkbXBj4hmvJ7e8hWCzA2RLlbxS9B4JZckAXSTbuaOkybSubj4q8ZyrAPC/0zRngjtuEkQBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243093; c=relaxed/simple;
	bh=BnhKen1S9a9A5miYPt17hcTb/eFYbuw/4wiIksV/RDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDD4RpdygmUg/oFFTVxnmmg2x2oaAJJOcJOrdUm7gfGuLdfsqLWJe8kxTnhWWQMqY7m9M9wzr47KATjnXx3UlND8hYTrY/8uPvmIbphUDL01IPOzLlShL0N7qEMohvLoNRJLvoEiuTRquEtgIP0I93F/1lZAbUMWL8Opimdl82I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZTjt4Hn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZTjt4Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C4A1F000FF;
	Sat, 12 Sep 2026 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243092;
	bh=R9/AuRQTLw7GBvmYa7AS1Pg5ZOicswPYxG8a6GOGLSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZTjt4HnF92kUbsl9Ny1SLDx/+5zTc90RW0LTo1kN+XT/bGtGnxgPqc6BisxBZET6
	 sxschKda9WIwLowjseI6kNwbYp0piSjbtHJ9tQV15r1KvVuPwB0+ts2nQUzGooLFHd
	 1kY2NjPCTXytO//e2H6GW30edSuQUVjzPDUPYCXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 633/798] arm64: hibernate: Restore DAIF state on error
Date: Sat, 12 Sep 2026 09:04:21 +0200
Message-ID: <20260912065531.632728832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 541549827889d0380fd73f8aacb5de6ef7a5a1ac ]

Sashiko AI has reported that if swsusp_mte_save_tags() for some reason
fails we return from swsusp_arch_suspend() with DAIF being masked -
that is not what we'd expect. Restore the saved DAIF state before
returning from the error path.

Fixes: ee11f332af96 ("arm64: mte: Save tags when hibernating")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hibernate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 3787c123bbd1d..9771bd34d26ca 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -414,8 +414,10 @@ int swsusp_arch_suspend(void)
 		crash_prepare_suspend();
 
 		ret = swsusp_mte_save_tags();
-		if (ret)
+		if (ret) {
+			local_daif_restore(flags);
 			return ret;
+		}
 
 		sleep_cpu = smp_processor_id();
 		ret = swsusp_save();
-- 
2.53.0



