Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC561C9B99;
	Tue,  8 Oct 2024 13:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392708; cv=none; b=hLCHGFLzcabkCrHqc1aHHuf7+caTAAl2HRn5uGNu+dkeB6rGNydd/RMM/q2bJyoc7cTG+4nG9MA4x3o6cQgUDfvpphH84a4jYR91hx+dt+AuNst/YyuonLP8B7wNGxUvxt9/iGK4CoNL4oDC+avdGqFuU7QJ2ebgHjWMHpW1oME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392708; c=relaxed/simple;
	bh=AtbTU2COA5VI0R2EOWbJW08xZaHbYwGeItUntr7PuAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/IWVl7y7a5x6WWLJXRog2PDw2N6tLZWurLVSjrEQPIi9DzRgLPXHnTIXQVxBE0q4FspW05xlfluyG09QTzSpBubsbgIRAHcumKMr0UzTyVP+qtuiz6tNMWN4xjEa9yovN+FF1nM7lQOL19/O40ZhMJS/51qKNbj7y5zgZkNtF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suqm7PRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suqm7PRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40DCC4CEC7;
	Tue,  8 Oct 2024 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392708;
	bh=AtbTU2COA5VI0R2EOWbJW08xZaHbYwGeItUntr7PuAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suqm7PRS3vCUs83wHJMtfWu8xFqtNXDTHGeKWvzwow2O2wqY1SlovwvXFz40yDQ1E
	 OiiZLmiNsWZcCqgDcQAyuLQLCHDP9SF/8sflILi4ZO2Uyirv5HotLlXwZ1R27AIbwW
	 Fe2peMSF3OGI62vKgZgY8Cc+S8PERN27oHeAXmCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Choong Yong Liang <yong.liang.choong@linux.intel.com>,
	KhaiWenTan <khai.wen.tan@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.11 478/558] net: stmmac: Fix zero-division error when disabling tc cbs
Date: Tue,  8 Oct 2024 14:08:28 +0200
Message-ID: <20241008115721.050173353@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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


