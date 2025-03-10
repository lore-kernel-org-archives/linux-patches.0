Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804B1A7264;
	Mon, 10 Mar 2025 17:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627984; cv=none; b=bCo4X4cHk1d+03ssbxwzeakbSgz4Jo7HQ/UREoZ57smSiMGu9bsBn49HRCN4oe997ZdyYVp8/3wr8QJbW8YC/04u7SGBmrtpNxLrILalzSdVIvTyJkgiRZS8uJQfrld/2X18wfGcIEbRgBLJRLZyBuvqgV7Gfdsju8FbW7SqSRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627984; c=relaxed/simple;
	bh=tPMeJnm1F4GHXdfx8QdsJb6qRw7BKE6xLXYnQcjJbr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLtD7X8Cbh8sslZLG4iGS65MmYzAvjdtMf+47NKYttMOaVSIROUjECDjWbJdjHXdv03Hk7St/glpUsaRiQmr5A3//bUZW1Z80dM1+uSnKa+ZfBbQsZsEqE2/MdJQBwDsCTutguwqfRG9jMGkmBiomQyU+ptAjB5ky+RaT9i3uM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrbA2MXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrbA2MXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13368C4CEE5;
	Mon, 10 Mar 2025 17:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627984;
	bh=tPMeJnm1F4GHXdfx8QdsJb6qRw7BKE6xLXYnQcjJbr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrbA2MXmhUW955QoVzVIBT8PxhIymLdy03y3o3E3FHvX7ncdgGevRbMxETnhRtr6f
	 lofXRbVbUQYNLjD9wyn761CqpVCaS7flSVJY7vdw/T5CAyPMjpDx95YHC3NM+vjKB0
	 ONy7oQeFH2ffjjvSFWWe3sgCq0d88dcZ47JJT8DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 048/145] Bluetooth: Add check for mgmt_alloc_skb() in mgmt_device_connected()
Date: Mon, 10 Mar 2025 18:05:42 +0100
Message-ID: <20250310170436.676970369@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d8df010f72b8a32aaea393e36121738bb53ed905 upstream.

Add check for the return value of mgmt_alloc_skb() in
mgmt_device_connected() to prevent null pointer dereference.

Fixes: e96741437ef0 ("Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_CONNECTED")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9679,6 +9679,9 @@ void mgmt_device_connected(struct hci_de
 				     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0) +
 				     eir_precalc_len(sizeof(conn->dev_class)));
 
+	if (!skb)
+		return;
+
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, &conn->dst);
 	ev->addr.type = link_to_bdaddr(conn->type, conn->dst_type);


