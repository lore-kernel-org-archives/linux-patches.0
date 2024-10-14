Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F360F1AC42C;
	Mon, 14 Oct 2024 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916503; cv=none; b=C5HRwfYFVwRFnKgawX1HlGKwOodtAsXXEIVs0+Y6XfLADc731Wu4KEsIvyvHc6H8TuyV4E++4hxPd+WKuv+ZxP8oG7Ij7vN6Jk6ribbGFtmz+6zkv2v08SDwN0e77+L9Sao9oTlBZhkZxR9G0LaZmtNMaUtPL/hZsDWAoHagmnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916503; c=relaxed/simple;
	bh=Ut8DJ8QCNpqka+OYJKs5Py1D3RBuPH8xLro9XAUBfDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTkMdllWcSRuTkoHaBbn1C1viQsMqKB5azEwZB0TS7ffBnhJQZU5unDF/uIts/2VksO3gGwW1N8KAJrhPwnkuQaZxooUvrZwCKkYMD7jYzXRBo5bzarZPkoa+neMRv/+QG5vXK/qhbAG6D2YRV1XUgLMgAIDkvWMDq8KDnohLd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALWjHs/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALWjHs/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E44C4CEC3;
	Mon, 14 Oct 2024 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916502;
	bh=Ut8DJ8QCNpqka+OYJKs5Py1D3RBuPH8xLro9XAUBfDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALWjHs/DwPrS511BUyf8H/4gCiMAzH2nuaHu++t6jjwtjrZfPBfyRxDjBTzdi1IDG
	 56eFUwU0tceIjtVNiL8bFo12MDehiUG7MVUvw346eF1NimnzLDaxMznCd6jsxGmEyU
	 bFlYLyC1AoleG0OyxgUZ6qRuaEW/11ZJYErlENIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 203/214] powercap: intel_rapl_tpmi: Fix bogus register reading
Date: Mon, 14 Oct 2024 16:21:06 +0200
Message-ID: <20241014141052.897822576@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

commit 91e8f835a7eda4ba2c0c4002a3108a0e3b22d34e upstream.

The TPMI_RAPL_REG_DOMAIN_INFO value needs to be multiplied by 8 to get
the register offset.

Cc: All applicable <stable@vger.kernel.org>
Fixes: 903eb9fb85e3 ("powercap: intel_rapl_tpmi: Fix System Domain probing")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Link: https://patch.msgid.link/20240930081801.28502-2-rui.zhang@intel.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_tpmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -192,7 +192,7 @@ static int parse_one_domain(struct tpmi_
 			pr_warn(FW_BUG "System domain must support Domain Info register\n");
 			return -ENODEV;
 		}
-		tpmi_domain_info = readq(trp->base + offset + TPMI_RAPL_REG_DOMAIN_INFO);
+		tpmi_domain_info = readq(trp->base + offset + TPMI_RAPL_REG_DOMAIN_INFO * 8);
 		if (!(tpmi_domain_info & TPMI_RAPL_DOMAIN_ROOT))
 			return 0;
 		domain_type = RAPL_DOMAIN_PLATFORM;


