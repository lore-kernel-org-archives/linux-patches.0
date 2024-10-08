Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DDF178384;
	Tue,  8 Oct 2024 12:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390831; cv=none; b=M1Ah4YZOpiGmdQFR5EBG4Kbl1QxP9xPD24qfVpXdS9QNVfWoN5UrLfgRoKgLRtHjz+4YgRx6HykU+GqiDzrz4d7TK6VpuZTkyVtZ+0UaAt1Fxv8GVjKBVLDiH/6RmYkbWC5ho7m8liednWKsHY0hzp2qwCrB3zjkJtxxifB8Q3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390831; c=relaxed/simple;
	bh=6z+SW5Ou73mvoU7Z6qwtXazVO/IZl1s0j3WDXLZHwxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRj1F441RpJw76VnTko5Y4XfJRKE66Nis4Msgpow2Hx+oY4oQn3bN4bbXoQ759qEjTG14nUqGery0iD0UPTNhMA1g83c8fwA5jdwEXcNSKszwwdfwJsz74+HqqRS0MO4iJFN03uPOoIBv9cGLNxgNR9K01DKBuI8yW5KpZwFUAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsVDr99E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsVDr99E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A9EC4CECE;
	Tue,  8 Oct 2024 12:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390831;
	bh=6z+SW5Ou73mvoU7Z6qwtXazVO/IZl1s0j3WDXLZHwxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsVDr99EGbXCngTCXzXXar+h1YPUF1ue82N8TD04pkCHzoILI5hxrf4JLOt3haIX1
	 atmr6DIcZDUxTaOCyvSe2aMtvnjf4M351MG452T0dgVw17Mkx3LJUyWpD0r87Zihj6
	 D14s6onbeh/e5n0Lj+tnxTmS+ibp9rBgaYkbg6KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Choong Yong Liang <yong.liang.choong@linux.intel.com>,
	KhaiWenTan <khai.wen.tan@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 407/482] net: stmmac: Fix zero-division error when disabling tc cbs
Date: Tue,  8 Oct 2024 14:07:50 +0200
Message-ID: <20241008115704.426426644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


