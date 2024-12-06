Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4F149C51;
	Fri,  6 Dec 2024 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496610; cv=none; b=NmeZ24NOvkHlxx0JTqw1zK4mKpeam9mdGYfGHYikGG3U4Z2cL04Y7kgZal6vx2kpW4oFF0o8pCS07NbmaxW6hSmdrHt0il1QY+L+6gtPIiGsCRTPJz1P2DOfT077jmPeSOuxcjNEJcgX2NjrwdxcZ3cIVjnP4jGRB4w/5yw+TQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496610; c=relaxed/simple;
	bh=slBbcAjWKDsYIAThWXN2jhuUeZbvbHRosalH7XFsvc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNT1mJ3St2787ikY6haCBZXIk0MF+akBOY19913gXlnI5je35EkHUuEYT+zJlZ8GwnwiFP7Yvp9vKn89joEn1zNt7pg7fMsDyIGnLTvyDUfG6nZMeaWv3VuQ9ZIu2JPy+OESPv6zs/Zkak8i09im62aeV/uunTjfMkHGo8OXHnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tST28Qs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tST28Qs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F44C4CED1;
	Fri,  6 Dec 2024 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496610;
	bh=slBbcAjWKDsYIAThWXN2jhuUeZbvbHRosalH7XFsvc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tST28Qs1D21yRnCBzJg8BNpbm56p3XjTsf6njJGIOvoBUbLEtl25p7h+nz5P09JEA
	 FzQDwPpVBaDOp6mZGFfvdHKKgTLNiqHyRsBLeEt3uO3R6X7ZfEIuGTHzqFNoNtBKag
	 FxwE+/0zvMNiKWRnMYzvEPqFiqs5C7QEANR5VIhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/676] x86/pvh: Set phys_base when calling xen_prepare_pvh()
Date: Fri,  6 Dec 2024 15:27:53 +0100
Message-ID: <20241206143655.462717781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c4365a05ab83b..c994ea58bdf7a 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -100,7 +100,20 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
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



