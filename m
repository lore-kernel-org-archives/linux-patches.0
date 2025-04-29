Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B3C3FFD;
	Tue, 29 Apr 2025 18:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949614; cv=none; b=cgkxZKzzIPy5JziB3A/X4XzmzgIYDkEO8LdWEyIUSYCTzq62N9EUL6ax5yVQ6YM6gurd8JgRVa9mm5GZhxWyeC9LnWXQgk6pIIy8DNOm+XkfBurRfnKjgok7B5Ei9NAgOZkEROvdMD0uZDSICGGbwHtuj+BvED8PpOCo5kGLbk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949614; c=relaxed/simple;
	bh=Qc9kSb1FQHxbwIDfMnenj8ki59a4aTq3ho15MkJkzyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyF8izLmEIPSX/DHCpTGmsH7AF/vZX1U0RWqj4sPmxXYqYpf/X10xzbLdrijhfTXeaTqwiDeqMSFgKmnNVy72gEzgdQskrhG+vwDuZn5oHJYpjq2o9z+hbFvhYJqLZHHVAGEBEFfX131F+OKnk0wmtwuCTTtaNzQ2bHA8gfJk5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ry7Xx1Lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ry7Xx1Lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740ADC4CEE3;
	Tue, 29 Apr 2025 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949613;
	bh=Qc9kSb1FQHxbwIDfMnenj8ki59a4aTq3ho15MkJkzyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ry7Xx1LmAI0UoESBXoGq8XCLhxeihTVThcB8n1rXO/xfZU+iGmuLVf3ADyX992/SJ
	 HPQVm5HOI2ifiVvhcLHiLptHZtrWGHEPmMrn/h3tjYLO8glERNRLhsio+JYuauNE3S
	 xftn7ikYMMtXdKWEbcNZf8aMWLXdFKgjhHiPccI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.15 373/373] PCI: Release resource invalidated by coalescing
Date: Tue, 29 Apr 2025 18:44:10 +0200
Message-ID: <20250429161138.475585812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <ross.lagerwall@citrix.com>

commit e54223275ba1bc6f704a6bab015fcd2ae4f72572 upstream.

When contiguous windows are coalesced by pci_register_host_bridge(), the
second resource is expanded to include the first, and the first is
invalidated and consequently not added to the bus. However, it remains in
the resource hierarchy.  For example, these windows:

  fec00000-fec7ffff : PCI Bus 0000:00
  fec80000-fecbffff : PCI Bus 0000:00

are coalesced into this, where the first resource remains in the tree with
start/end zeroed out:

  00000000-00000000 : PCI Bus 0000:00
  fec00000-fecbffff : PCI Bus 0000:00

In some cases (e.g. the Xen scratch region), this causes future calls to
allocate_resource() to choose an inappropriate location which the caller
cannot handle.

Fix by releasing the zeroed-out resource and removing it from the resource
hierarchy.

[bhelgaas: commit log]
Fixes: 7c3855c423b1 ("PCI: Coalesce host bridge contiguous apertures")
Link: https://lore.kernel.org/r/20230525153248.712779-1-ross.lagerwall@citrix.com
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v5.16+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -999,8 +999,10 @@ static int pci_register_host_bridge(stru
 	resource_list_for_each_entry_safe(window, n, &resources) {
 		offset = window->offset;
 		res = window->res;
-		if (!res->flags && !res->start && !res->end)
+		if (!res->flags && !res->start && !res->end) {
+			release_resource(res);
 			continue;
+		}
 
 		list_move_tail(&window->node, &bridge->windows);
 


