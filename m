Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A43F143889;
	Tue, 23 Apr 2024 21:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908492; cv=none; b=OMSyKS/uwC5eNbOSTlG0ovBGD9oEB0Vb1xVhnqjARA6o+OKwg4OKFBj56o0ReJvPrc1m80rTVnkki2ndRbhfODqUyzwBqoOJGCgLF2MZecnLGlHuUz7Q7/A0lGfO2OuZDHEhvRExhzRV3KETnA9fh9j2FO+hGo8ybMsayEHIaVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908492; c=relaxed/simple;
	bh=CdJ5/+3ESPLwHo/Gi0pzy2eWy2xqtcFTPZD9W+Xj82M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spHfc/5LS6bbhnCpFfFB5mwV8aJBXn1xNY1bPjFl3YIBV8ThHWuh98xR9O5aThyiHcgSIckyGs4QuaE8du/cTNbmYK8Xex/h7QgFXRMGNOtHq4NUHWxPs2X9TGd9hcGqMXwMWp/u1mrdcZO+K9cIUGYsIaJeNYNTIPKiWVG+RUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NrUygH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NrUygH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9C8C116B1;
	Tue, 23 Apr 2024 21:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908492;
	bh=CdJ5/+3ESPLwHo/Gi0pzy2eWy2xqtcFTPZD9W+Xj82M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NrUygH4BWwqdET1+eQLPUggxIdxJWaVaPOyDblzu9Y8/6r3f0DeZNDhR0ZSPEXJd
	 Tzt/rjERrI0nX4PyBjuQem9UI8KCLDCvKV2jO4sq9XClGpzrnzOg7ESM55eYhTw+mw
	 WH12rqvsWI/ukUWK0qTA/R0sdiJMZnzdhCucKrE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanath S <Sanath.S@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.8 068/158] thunderbolt: Introduce tb_path_deactivate_hop()
Date: Tue, 23 Apr 2024 14:38:10 -0700
Message-ID: <20240423213858.168958912@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanath S <Sanath.S@amd.com>

commit b35c1d7b11da8c08b14147bbe87c2c92f7a83f8b upstream.

This function can be used to clear path config space of an adapter. Make
it available for other files in this driver.

Signed-off-by: Sanath S <Sanath.S@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/path.c |   13 +++++++++++++
 drivers/thunderbolt/tb.h   |    1 +
 2 files changed, 14 insertions(+)

--- a/drivers/thunderbolt/path.c
+++ b/drivers/thunderbolt/path.c
@@ -446,6 +446,19 @@ static int __tb_path_deactivate_hop(stru
 	return -ETIMEDOUT;
 }
 
+/**
+ * tb_path_deactivate_hop() - Deactivate one path in path config space
+ * @port: Lane or protocol adapter
+ * @hop_index: HopID of the path to be cleared
+ *
+ * This deactivates or clears a single path config space entry at
+ * @hop_index. Returns %0 in success and negative errno otherwise.
+ */
+int tb_path_deactivate_hop(struct tb_port *port, int hop_index)
+{
+	return __tb_path_deactivate_hop(port, hop_index, true);
+}
+
 static void __tb_path_deactivate_hops(struct tb_path *path, int first_hop)
 {
 	int i, res;
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1154,6 +1154,7 @@ struct tb_path *tb_path_alloc(struct tb
 void tb_path_free(struct tb_path *path);
 int tb_path_activate(struct tb_path *path);
 void tb_path_deactivate(struct tb_path *path);
+int tb_path_deactivate_hop(struct tb_port *port, int hop_index);
 bool tb_path_is_invalid(struct tb_path *path);
 bool tb_path_port_on_path(const struct tb_path *path,
 			  const struct tb_port *port);


