Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAA01170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA2BC433C7;
	Mon, 11 Sep 2023 14:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442206;
	bh=t2+dNxsqc1b+FbjZ8GIFxJyDGKk0y6Rldb8MqquwHwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLSBT2MU5d5L8b+O6GO9oZ3ssguqfSwuH5r4JnEP1K8m155aU+9UgTUBwmMyUrFyV
	 yr/wlQsafRAfE1wvbVVSwhtRpyf8vYawC5W9Oh3HgESMVya3lWlMZ7W1o9bh8uQuI+
	 +n/PS5zO/NbYkYVh2q/8ShrKN0M2UnYo7/8KMy3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Valo <kvalo@kernel.org>,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.5 684/739] PCI: Free released resource after coalescing
Date: Mon, 11 Sep 2023 15:48:03 +0200
Message-ID: <20230911134710.203104238@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <ross.lagerwall@citrix.com>

commit 8ec9c1d5d0a5a4744516adb483b97a238892f9d5 upstream.

release_resource() doesn't actually free the resource or resource list
entry so free the resource list entry to avoid a leak.

Closes: https://lore.kernel.org/r/878r9sga1t.fsf@kernel.org/
Fixes: e54223275ba1 ("PCI: Release resource invalidated by coalescing")
Link: https://lore.kernel.org/r/20230906110846.225369-1-ross.lagerwall@citrix.com
Reported-by: Kalle Valo <kvalo@kernel.org>
Tested-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org      # v5.16+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -998,6 +998,7 @@ static int pci_register_host_bridge(stru
 		res = window->res;
 		if (!res->flags && !res->start && !res->end) {
 			release_resource(res);
+			resource_list_destroy_entry(window);
 			continue;
 		}
 


