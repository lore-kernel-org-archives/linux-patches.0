Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F3A43AA9;
	Mon, 14 Oct 2024 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919422; cv=none; b=AwDaOhAGlfZF0sdVZa9+0eQjChSkbyoNg6xeLGyTCMMdBo5ZepDPcytXiRsa/vFiPdjT+V3/QlwwsAq0/3PpVSRNQe7ETLSsXiN8hFxbbWCrKkPdEHkpL5fuJHQ87XQ+ioBTZH7PsqaVDzoguVRQpMY8KTJrqYgo9SqhKPNPQ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919422; c=relaxed/simple;
	bh=Tre9cGAyKoXv/5RfMTecMjEAbcsd53B4l8ULKRqHIro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXlkpXxreoXju3i/USCAA5453UZCGSHp80RK6BQBYUEjAix6I0hyKjLcGPDHeImCHLP5bgxKAAStVt3TInzmXl9u4Db75kpVAlebipFUCLRh4U3+NfPNIKkdnRe7ly1SwcnXBl86/mq2KJ5dHjAndxNId5Pp1W3St9hsaOcwEIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgVNWLx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgVNWLx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45805C4CEC3;
	Mon, 14 Oct 2024 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919422;
	bh=Tre9cGAyKoXv/5RfMTecMjEAbcsd53B4l8ULKRqHIro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgVNWLx6cWNVTEtll844cNIoR6RY6rAmFVPZbTZum68FceQoosxhzH3XrYq4KSe7t
	 Ze52m+eyvcMbysQPZhqrhVKhctxL+VWajQ+Xx/BIy2txT+iLQZZzDpLsirfm0xlpgC
	 WRGWJm1/dbP8O2/jQwcQ87HvX6bpdfpfyCDAPikU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Choong Yong Liang <yong.liang.choong@linux.intel.com>,
	KhaiWenTan <khai.wen.tan@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 597/798] net: stmmac: Fix zero-division error when disabling tc cbs
Date: Mon, 14 Oct 2024 16:19:11 +0200
Message-ID: <20241014141241.459094809@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KhaiWenTan <khai.wen.tan@linux.intel.com>

commit 675faf5a14c14a2be0b870db30a70764df81e2df upstream.

The commit b8c43360f6e4 ("net: stmmac: No need to calculate speed divider
when offload is disabled") allows the "port_transmit_rate_kbps" to be
set to a value of 0, which is then passed to the "div_s64" function when
tc-cbs is disabled. This leads to a zero-division error.

When tc-cbs is disabled, the idleslope, sendslope, and credit values the
credit values are not required to be configured. Therefore, adding a return
statement after setting the txQ mode to DCB when tc-cbs is disabled would
prevent a zero-division error.

Fixes: b8c43360f6e4 ("net: stmmac: No need to calculate speed divider when offload is disabled")
Cc: <stable@vger.kernel.org>
Co-developed-by: Choong Yong Liang <yong.liang.choong@linux.intel.com>
Signed-off-by: Choong Yong Liang <yong.liang.choong@linux.intel.com>
Signed-off-by: KhaiWenTan <khai.wen.tan@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240918061422.1589662-1-khai.wen.tan@linux.intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -396,6 +396,7 @@ static int tc_setup_cbs(struct stmmac_pr
 			return ret;
 
 		priv->plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_DCB;
+		return 0;
 	}
 
 	/* Final adjustments for HW */


