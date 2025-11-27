Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A9725BEE8;
	Thu, 27 Nov 2025 14:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255083; cv=none; b=Sv+suqMwBdqqjTfoXGTAJBSPlJNTFLDihpmORHQMirl/2njKfnN42PFwWuCNHcYwpkmBNo7MEc0TQWvuhgIW6S/upK5AXW5BHW55+Ao82xanwu5YmL0TUzPUXufME9TQldxulY/bd8bCwxn4bubdmUEaB346urS+jxKV4XOMFc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255083; c=relaxed/simple;
	bh=Q/66rYVRk0/IBh9u1u5I2XBRhigjlyVB5XMbS6hmUDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeIf5f6IbvSlGC6rC+LIdhVLDBZca9H6xFP0QsXUegMrGlTPCz1laP8zIbTi4XXNYDubeNgoI9nygaBCKAHmIlElNG0wx23jzUVMELrssDrk/CREIgXtBD60xsDQZERVWx4I4+FqBC62vd/G0f3arLd/igmFljkZ4HuslYBa+2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZ7geTa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZ7geTa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4194FC4CEF8;
	Thu, 27 Nov 2025 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255083;
	bh=Q/66rYVRk0/IBh9u1u5I2XBRhigjlyVB5XMbS6hmUDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZ7geTa/FCeXtA9M63vEUVOQ/Nj9FCcMwOBdeHX6oxssIuOX5k8QtEC05vpu5nDiY
	 mTNh/8TqOGosSVDEn0/lLSfgm+ub5c84SlMfzpoXC9ocOYGigy3IY9NgiTqMQArMfP
	 chGTQBqWx+L9Ein/EyR6cQRTjg/jLB1z2RZemFWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 61/86] x86/microcode/AMD: Limit Entrysign signature checking to known generations
Date: Thu, 27 Nov 2025 15:46:17 +0100
Message-ID: <20251127144030.061038593@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 8a9fb5129e8e64d24543ebc70de941a2d77a9e77 ]

Limit Entrysign sha256 signature checking to CPUs in the range Zen1-Zen5.

X86_BUG cannot be used here because the loading on the BSP happens way
too early, before the cpufeatures machinery has been set up.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/all/20251023124629.5385-1-bp@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/amd.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index f9b6e2043e6b2..9952c774eaa69 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -226,6 +226,24 @@ static bool need_sha_check(u32 cur_rev)
 	return true;
 }
 
+static bool cpu_has_entrysign(void)
+{
+	unsigned int fam   = x86_family(bsp_cpuid_1_eax);
+	unsigned int model = x86_model(bsp_cpuid_1_eax);
+
+	if (fam == 0x17 || fam == 0x19)
+		return true;
+
+	if (fam == 0x1a) {
+		if (model <= 0x2f ||
+		    (0x40 <= model && model <= 0x4f) ||
+		    (0x60 <= model && model <= 0x6f))
+			return true;
+	}
+
+	return false;
+}
+
 static bool verify_sha256_digest(u32 patch_id, u32 cur_rev, const u8 *data, unsigned int len)
 {
 	struct patch_digest *pd = NULL;
@@ -233,7 +251,7 @@ static bool verify_sha256_digest(u32 patch_id, u32 cur_rev, const u8 *data, unsi
 	struct sha256_state s;
 	int i;
 
-	if (x86_family(bsp_cpuid_1_eax) < 0x17)
+	if (!cpu_has_entrysign())
 		return true;
 
 	if (!need_sha_check(cur_rev))
-- 
2.51.0



