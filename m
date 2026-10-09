Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BBF4CCDC0;
	Fri,  9 Oct 2026 14:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556762; cv=none; b=d4O86HaABiavO7g8boy6YLwW+QvIyXfa7K7g7s84ozMBigHm+lxOhX3WMH29GyssOUfBl96Of2wD0GdWGCvHIQT1XEb/M8GgOyIIYkXZll1MohEJNwpBalaFFNGUx849qm/PRi9A9NAYep3bdhKzMEh36udu4jOkxldtA2d9dUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556762; c=relaxed/simple;
	bh=8q/AOrhNgd0NG3YnByEbMeiAXhlI1QZHg00STCQ+vLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYDVkk7DdNBHawn/Za8W5D5gaol6XjYzaTuZSqWakSUG2zOaDrW/LbwXrKzmoEEtUBG6fOmDwDWFMC9Hsw91w5bUGIxebYnTZO6DeoLCCJet2/jf9mqBBIctNDrlfGmvwn2edgUHXd1BPa11Wdv4UNU7g3hisBVL249GlTUrW1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWZYODuv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWZYODuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4AC1F000FF;
	Fri,  9 Oct 2026 14:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556761;
	bh=mm+z9o+izm6013npnq8XxowT/PstRh6UTgcXkoi0ZaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWZYODuvafhqb29G9d0N8wtq4hBdwj+uxLTABw+pPeRZWWKL3QalCHMGoI+afCtG1
	 6nCzM+OOoI1fsWU1BFOkOJMNjuw/ItxFJnh5DlQPsStXwlfv7ztyo3ln4C0jyM8Nkq
	 qzc/G8TCKw+PeJlPIT1kk34swlnGGIWbvcFXD57g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 289/403] thunderbolt: Mark discovered tunnels as active
Date: Fri,  9 Oct 2026 16:10:50 +0200
Message-ID: <20261009140958.958694539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

commit c222f80be55f6c17851af1c68a70ae4046c848e2 upstream.

Discovered tunnels that have been activated by whatever was running
before us stay in TB_TUNNEL_INACTIVE until hibernation restore such that
anything depending on tb_tunnel_is_active() skips them. Mark them active
during discovery instead. These now also emit TUNNEL_EVENT=activated
uevents during discovery.

Fixes: d6d458d42e1e ("thunderbolt: Handle DisplayPort tunnel activation asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tunnel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -513,6 +513,7 @@ struct tb_tunnel *tb_tunnel_discover_pci
 		goto err_deactivate;
 	}
 
+	tb_tunnel_set_active(tunnel, true);
 	tb_tunnel_dbg(tunnel, "discovered\n");
 	return tunnel;
 
@@ -1659,6 +1660,7 @@ struct tb_tunnel *tb_tunnel_discover_dp(
 
 	tb_dp_dump(tunnel);
 
+	tb_tunnel_set_active(tunnel, true);
 	tb_tunnel_dbg(tunnel, "discovered\n");
 	return tunnel;
 
@@ -2287,6 +2289,7 @@ struct tb_tunnel *tb_tunnel_discover_usb
 			tb_usb3_reclaim_available_bandwidth;
 	}
 
+	tb_tunnel_set_active(tunnel, true);
 	tb_tunnel_dbg(tunnel, "discovered\n");
 	return tunnel;
 


