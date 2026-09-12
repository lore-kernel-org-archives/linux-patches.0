Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77062882AB;
	Sat, 12 Sep 2026 16:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230955; cv=none; b=UPkPtdyliz11uKG51Nah1P1yGvfnSh6Iu+JRmfWrNHp2RI1B38B+arlnkdf4gF4sNtBju88ZeZkwrafA9TPYzQ+7TloCmt766JeSN6CXvDrT4dywZw8uu6CL+eSG9J/OW31qTw81Qr8jI4GQqXO8/KmRRot5WLKa+53VaSboXRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230955; c=relaxed/simple;
	bh=7gZmyvItE8AtY33ZAVWzXzYzrN4m5WPTnbTENFqK/zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwFCFe20XyKrbIfwTGh0lxIgf24m+KDajhdofqQuruUIXtc5x8RQXbFGFHMfRW2YE0f3JgiC/6Zt3kolbOSTIh0zq8id57uHe3FfEjOyiPsF3nN5LmMhi7OS7cD9smz5AxY2XHutJ1rPIUoHf51lW9J/91U21MIQcmjh6uxLj4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xd7fVmHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xd7fVmHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF8F1F000FF;
	Sat, 12 Sep 2026 16:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230954;
	bh=C54LH/2Q7e8/o4wJSoun2ZZC7CP3xZR1chzKeNXnvws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xd7fVmHNr0emyl5aSdH0V7wHC3gQNJ5HsfKjfG6HCAkodWSGYQkw5ZcCAO25wyWlv
	 qNQboUtFF88AVblFI0h20lC13tApeYxDZ7Pl39x2/udu4PHGj4bDPGydBzN8XDplLs
	 RJn46/fmD31o0m/JZ/jOuE4X02FZYo+fzvHmtKno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0900/1191] arm64: hibernate: Restore DAIF state on error
Date: Sat, 12 Sep 2026 09:00:28 +0200
Message-ID: <20260912065608.451276408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 97c204e169773..dc9e62e992daa 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -343,8 +343,10 @@ int swsusp_arch_suspend(void)
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



