Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BDE13B5B6;
	Tue,  3 Dec 2024 14:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237749; cv=none; b=W/CnRs95RkHN5kbyJ8+MgpYw7vP2vfb7mzn0drARip7jjNL9dBtoSYfivu+4zsH4F09ZpzHgtNgM7dE2nRnEz+KqsbuH7Q4n5MAyRpXNaeDCZIYecC5JIcaBG6BZDtKVSzulp3PmCyAxPvRuOQdmDmb9NNuCDWfAEf7dMThWctE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237749; c=relaxed/simple;
	bh=Avty/+hbd18Ubf/+lL4I90u+hm/TZNZ38lSj4ndnQXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOQJUjxS390pwgU+5Ylx+NkFdOa9KHyQf4rdzWa9LPh1DYf7l8qrLNb0N4lzfbct/wugNYCdy6uu1VrYZG4gS1opgQt0yo/fjYYnqiAlLUP9SSzXW1INDPc20zNiDIHLLmTwnvEFb813+qC8BnlGgYDNPa+iIyKdkShQ3Vi0GxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRxJ20Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRxJ20Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3506C4CECF;
	Tue,  3 Dec 2024 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237749;
	bh=Avty/+hbd18Ubf/+lL4I90u+hm/TZNZ38lSj4ndnQXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRxJ20YelYByecpNo7cmcgSwg15g8Zg707eFQiu7ffVZNUL58E1FusaWBU0l4BELL
	 AHW4zPNc7pJFjDVEheBImkh+GOWz4fZQEXSs5p+1hz2H5Gl+mzbcB67BTfons+5hSe
	 lBeGrnvROgZZiYAvNfPfCi7Jcydei4mSEwzUkN6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 059/817] x86/pvh: Set phys_base when calling xen_prepare_pvh()
Date: Tue,  3 Dec 2024 15:33:51 +0100
Message-ID: <20241203143957.987506641@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit b464b461d27d564125db760938643374864c1b1f ]

phys_base needs to be set for __pa() to work in xen_pvh_init() when
finding the hypercall page.  Set it before calling into
xen_prepare_pvh(), which calls xen_pvh_init().  Clear it afterward to
avoid __startup_64() adding to it and creating an incorrect value.

Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20240823193630.2583107-4-jason.andryuk@amd.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: e8fbc0d9cab6 ("x86/pvh: Call C code via the kernel virtual mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/pvh/head.S | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
index f7235ef87bc32..3621293cd1cc2 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -101,7 +101,20 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
 	xor %edx, %edx
 	wrmsr
 
+	/*
+	 * Calculate load offset and store in phys_base.  __pa() needs
+	 * phys_base set to calculate the hypercall page in xen_pvh_init().
+	 */
+	movq %rbp, %rbx
+	subq $_pa(pvh_start_xen), %rbx
+	movq %rbx, phys_base(%rip)
 	call xen_prepare_pvh
+	/*
+	 * Clear phys_base.  __startup_64 will *add* to its value,
+	 * so reset to 0.
+	 */
+	xor  %rbx, %rbx
+	movq %rbx, phys_base(%rip)
 
 	/* startup_64 expects boot_params in %rsi. */
 	mov $_pa(pvh_bootparams), %rsi
-- 
2.43.0



