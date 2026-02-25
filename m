Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CA22701DA;
	Wed, 25 Feb 2026 01:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983780; cv=none; b=V5VZLG4juV/6VHXrA6uZsb0pLjpvML0AbaN5HRwcAmy1RSt7xIT5Vslee7X79Z+yevbwx9Uja93r0/iSVFBlHWQIeJV4bKJuLCkhvqr/1KWzMwsuO4djO4vwj344Dy1aEymdE7x+Y9TM7xUcDgLPmqJFhFvPRoGaV2tSmI3WrDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983780; c=relaxed/simple;
	bh=FJt6Ied6r8OOefhDd3ZpdtU6fQDMGk0inH7HW3lpXWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJyz1HRDM7EHo1osGu9GhRQxr9H5usPKtZ7y55mpqj/97Hq9miIx+0HhGPOG3iJ1gCw3mBH0wZTKqIq9S60e/Y2tGLOC/xq/UNFpOcwy92jjnOEbnPKf81bLHqbt+4sEFp/sYjyt+66oan9d0NPj1RL6hh+sEUTMu0Q1uew3jFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sz9KOGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sz9KOGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4CAC116D0;
	Wed, 25 Feb 2026 01:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983779;
	bh=FJt6Ied6r8OOefhDd3ZpdtU6fQDMGk0inH7HW3lpXWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sz9KOGTFFd3/1rhz/JQhZ1pXqpUKIg0hFnBINIZe4oUuc/c9/9RVlBzq05bpdBue
	 aroQpNWLUVTgFi650356uHzNiAIqYf814zP8pnTh0q6ZLzE8UtKHKQksdsxMFdm3J/
	 xuv0CjEFa8mhFvGLjWS/OORPFswo4ZZOyF7QxXE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/641] ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
Date: Tue, 24 Feb 2026 17:16:35 -0800
Message-ID: <20260225012350.734094490@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b9fecf0dddfc55cd7d02b0011494da3c613f7cde ]

The vDSO code hides symbols which are non-functional.
__vdso_clock_getres() was not added to this list when it got introduced.

Fixes: 052e76a31b4a ("ARM: 8931/1: Add clock_getres entry point")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20251223-vdso-compat-time32-v1-6-97ea7a06a543@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/vdso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/vdso.c b/arch/arm/kernel/vdso.c
index e38a30477f3d7..566c40f0f7c77 100644
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -161,6 +161,7 @@ static void __init patch_vdso(void *ehdr)
 		vdso_nullpatch_one(&einfo, "__vdso_gettimeofday");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime64");
+		vdso_nullpatch_one(&einfo, "__vdso_clock_getres");
 	}
 }
 
-- 
2.51.0



