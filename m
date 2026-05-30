Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677D4320CAD;
	Sat, 30 May 2026 17:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163456; cv=none; b=CZ9nK25CpWuclfsr/M5CGDmcaU+bIARavJYgxA6wtVhWULz1RBbgyB2kT3/OqLkkG6i5zAfzX1oHYfJinxX6+iJNWVoh+/M3jPosH7D5XsuG/9ha9Yutj48y7Sx00Ji+N8svcfqO9e3278WrbVr9COpQboX4ywHdLR4Xyiupjko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163456; c=relaxed/simple;
	bh=FtDPm50zNsLsiVO4iEGZF+hhrXBNDbgNjL2wJ1osRes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQQi/1QvJ/HXsTX7Eqom5Lyx/tULRHfcRmmHVSx9bg88cID3gwLyIis2sG+15ILlFTlzkTos5fSVAwNvIvMtwY8mJ8gz5auICebzhvlXF5rDeG3evGCIXE1CD212ZJgRLDyRL6X9EhXgwfcpNa+waGjG/FQS2Z/iw1zzb8HwcV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SH42ClCO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SH42ClCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8121F00893;
	Sat, 30 May 2026 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163455;
	bh=VTtqZJRrfWp+hC8+JoPp9Hb+f6hd+z/fknt1B9c5m2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SH42ClCOzFSjRLTpz6n+TxR5b7sWvWTttLjn34ZTtBz4aUpgZV/2GyBOAwojt2d4n
	 NldZ5KXRAmEE2Fa7ZZxRHoqVAYdP7LOvTCdaJKT74ghX95QHPrhSvOwH1ayna0PtvK
	 nI28wNndPyMfXR2+RzCMmQM7gtiTE+3XQCeVghC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Cheng <chengkev@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 234/776] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
Date: Sat, 30 May 2026 17:59:08 +0200
Message-ID: <20260530160246.579116039@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Cheng <chengkev@google.com>

commit d99df02ff427f461102230f9c5b90a6c64ee8e23 upstream.

INVLPGA should cause a #UD when EFER.SVME is not set. Add a check to
properly inject #UD when EFER.SVME=0.

Fixes: ff092385e828 ("KVM: SVM: Implement INVLPGA")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Cheng <chengkev@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260228033328.2285047-3-chengkev@google.com
[sean: tag for stable@]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2363,6 +2363,9 @@ static int invlpga_interception(struct k
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);
 
+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
 	/* FIXME: Handle an address size prefix. */
 	if (!is_long_mode(vcpu))
 		gva = (u32)gva;


