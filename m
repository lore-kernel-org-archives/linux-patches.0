Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42081F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E5BC433CA;
	Fri, 21 Jul 2023 16:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956333;
	bh=iAoqKB9WFuX1v43fLLa5o//KLBmgW7TcxCgo7buNeb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmvJXrs2xeJ6mttuc7+mobvwej3PE+EkRfjf30NNFp5skqcHi15AfTWwPLA5EzHFN
	 uEcHUpNtnAEyb9n48MR6suWjUnXCjIahRdnpsydJVMPML7taZjZEfJ/5xsiSgTKfJB
	 NDqXp4etIZ96J6BrY7Og/4dvzWSzoJ9TeBeEYWDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.4 170/292] PCI: Release resource invalidated by coalescing
Date: Fri, 21 Jul 2023 18:04:39 +0200
Message-ID: <20230721160536.209433422@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
@@ -997,8 +997,10 @@ static int pci_register_host_bridge(stru
 	resource_list_for_each_entry_safe(window, n, &resources) {
 		offset = window->offset;
 		res = window->res;
-		if (!res->flags && !res->start && !res->end)
+		if (!res->flags && !res->start && !res->end) {
+			release_resource(res);
 			continue;
+		}
 
 		list_move_tail(&window->node, &bridge->windows);
 


