Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6224D211A2A;
	Wed,  7 May 2025 18:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643931; cv=none; b=Z2BI5SfMGo9q2h/GMnR8YeQct+adWO2wnAKD09KUpYAENXsURcz0zgGVqbquzkLnfDqS16VR2NrMoZEvlkrmqjXKurt63G/ybFI3uFStT/nSHb+Fv7HCvyJyTkTUycLc8QVoyBrZP6Cn5b5Vf1yJvpO8RZ48mUS5AYOir7wYBlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643931; c=relaxed/simple;
	bh=KetDZUCirod2W1v+aZdVqfpKCGcknLM8dV6FoOc01Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQpXAkbIdHusG0YuO+ZXMVoIKlc8QM8RhIymzp77rbavgmMLeo/Lk2DpFfeqO0MjmhVJNgoJC/G7hs2UmjNsj2cPhph15+r+rKejNTSax6l1VfvnJ1oaO39PvLU9pVs9GK/P/vXHe2uE4ESyQNtR5KJeDWAvUhNtz48142VeL+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUzP+Bi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUzP+Bi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C482EC4CEE2;
	Wed,  7 May 2025 18:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643931;
	bh=KetDZUCirod2W1v+aZdVqfpKCGcknLM8dV6FoOc01Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUzP+Bi/Kyw4HhGt8lRniQgwipVm0UFSVgezYrYZ9Brv+uHLKRjSgCvNtpdsutlJp
	 L5rdG6K3Xna3DfHyd6bTYuV12B+g6llk2Yy+JRVrYjx2wlM7nF0wZQCeTWVAEXe8rg
	 2WspuKJC0ibcqU9Mf61tX1bKzlw/+6nwGDxvfsxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 065/183] powerpc/boot: Fix dash warning
Date: Wed,  7 May 2025 20:38:30 +0200
Message-ID: <20250507183827.326868914@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit e3f506b78d921e48a00d005bea5c45ec36a99240 ]

'commit b2accfe7ca5b ("powerpc/boot: Check for ld-option support")' suppressed
linker warnings, but the expressed used did not go well with POSIX shell (dash)
resulting with this warning

arch/powerpc/boot/wrapper: 237: [: 0: unexpected operator
ld: warning: arch/powerpc/boot/zImage.epapr has a LOAD segment with RWX permissions

Fix the check to handle the reported warning. Patch also fixes
couple of shellcheck reported errors for the same line.

In arch/powerpc/boot/wrapper line 237:
if [ $(${CROSS}ld -v --no-warn-rwx-segments &>/dev/null; echo $?) -eq 0 ]; then
     ^-- SC2046 (warning): Quote this to prevent word splitting.
       ^------^ SC2086 (info): Double quote to prevent globbing and word splitting.
                                            ^---------^ SC3020 (warning): In POSIX sh, &> is undefined.

Fixes: b2accfe7ca5b ("powerpc/boot: Check for ld-option support")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250423082154.30625-1-maddy@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/wrapper | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index 267ca6d4d9b38..3d8dc822282ac 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -234,7 +234,7 @@ fi
 
 # suppress some warnings in recent ld versions
 nowarn="-z noexecstack"
-if [ $(${CROSS}ld -v --no-warn-rwx-segments &>/dev/null; echo $?) -eq 0 ]; then
+if "${CROSS}ld" -v --no-warn-rwx-segments >/dev/null 2>&1; then
 	nowarn="$nowarn --no-warn-rwx-segments"
 fi
 
-- 
2.39.5



