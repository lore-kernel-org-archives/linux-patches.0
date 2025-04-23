Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAF1175BF;
	Wed, 23 Apr 2025 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420016; cv=none; b=VjTTZe7LT4kP4MITQr2WPKEvPbSUsajHcXLzR7Xi0q5bcbXjiJ/wg379qvXStLukoxIE5gYEqvbsvVTbN1MseVcz5jJ/7CjC96DSfISdQwHWtTX6fjhuvBGTd3aUqimHgCE5ybQcOPyBHEvvXkggI58j+S9UzaV5LqtTvK3L/p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420016; c=relaxed/simple;
	bh=Ac0NspLDLPtRRtZaA4c+j/b5WbeyF1YQTfK7aXtCx48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsOP+ZrtnamSlRV94tFIPAxdFXwYZp06q4nMXZ0RaHA/iziJ0HErfEPZwAQekwny0v+tO8ERipv7Axj9iWp6Sgl9EoJ8VLv2y87n9zX5q32tDrceN3bLtfrR1IVhkvHNo4OaYp3Z80SgUsXUwd728HiEGl4VMDaVuACoDptvt88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ONmqbAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ONmqbAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5524DC4CEE2;
	Wed, 23 Apr 2025 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420015;
	bh=Ac0NspLDLPtRRtZaA4c+j/b5WbeyF1YQTfK7aXtCx48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ONmqbAlHJ4ZoqOKIJKDDBo5izb9eHM2p0Hyo94yQbnzNvpdQM3EHxqpj/cmLxQPk
	 YULWuDK0mFAd3YDR45UjoW/vy66IyGwqfbKt9BXTG8fM5PEp0iBeTFgFDRYN31GOEB
	 NWcN4i42vsEy2jsI8iZ/j5IT768K5N6w11QoDmeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 052/241] netlink: specs: ovs_vport: align with C codegen capabilities
Date: Wed, 23 Apr 2025 16:41:56 +0200
Message-ID: <20250423142622.633013128@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 747fb8413aaa36e4c988d45c4fe20d4c2b0778cd ]

We started generating C code for OvS a while back, but actually
C codegen only supports fixed headers specified at the family
level right now (schema also allows specifying them per op).
ovs_flow and ovs_datapath already specify the fixed header
at the family level but ovs_vport does it per op.
Move the property, all ops use the same header.

This ensures YNL C sees the correct hdr_len:

   const struct ynl_family ynl_ovs_vport_family =  {
          .name           = "ovs_vport",
  -       .hdr_len        = sizeof(struct genlmsghdr),
  +       .hdr_len        = sizeof(struct genlmsghdr) + sizeof(struct ovs_header),
   };

Fixes: 7c59c9c8f202 ("tools: ynl: generate code for ovs families")
Link: https://patch.msgid.link/20250409145541.580674-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/ovs_vport.yaml | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/netlink/specs/ovs_vport.yaml b/Documentation/netlink/specs/ovs_vport.yaml
index 86ba9ac2a5210..b538bb99ee9b5 100644
--- a/Documentation/netlink/specs/ovs_vport.yaml
+++ b/Documentation/netlink/specs/ovs_vport.yaml
@@ -123,12 +123,12 @@ attribute-sets:
 
 operations:
   name-prefix: ovs-vport-cmd-
+  fixed-header: ovs-header
   list:
     -
       name: new
       doc: Create a new OVS vport
       attribute-set: vport
-      fixed-header: ovs-header
       do:
         request:
           attributes:
@@ -141,7 +141,6 @@ operations:
       name: del
       doc: Delete existing OVS vport from a data path
       attribute-set: vport
-      fixed-header: ovs-header
       do:
         request:
           attributes:
@@ -152,7 +151,6 @@ operations:
       name: get
       doc: Get / dump OVS vport configuration and state
       attribute-set: vport
-      fixed-header: ovs-header
       do: &vport-get-op
         request:
           attributes:
-- 
2.39.5



