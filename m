Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11963D8137;
	Wed, 20 May 2026 17:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298024; cv=none; b=lRPey+T5TW8SavcBssiqV0H/0kTtPPHMQYEHkKqtQ5Un370xoJ1hkmD2YOY1c3mgyCWpsYvENIf7T/2SGiHEJlF0IotCwOcymYlUPpG+l/wIck84cCAoGoZJxtnRODi25rW1n+EkHX25z1JlSQ5FpDG1YBiD8AXgj+4QbIDIWuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298024; c=relaxed/simple;
	bh=PqxpGXb109g7CFPLZgdx+T5UZ2jP8zORe+h8MNUWuzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VrqTotr/G2zVid3WnTEBG69gecL9hHYWtB3MKubTNU4gB65qssdjIcvGLggj+IW/t2vJaJw9JipfgXg+adsqPFMpAE3fzRLihOLfVavDsjLZe/iumQfi1HZql1Xve7VsDTrAclOzZPlByD1QxepKJ1yYQVGcK5Ghe30XvKyLfYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gf9dsF4O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gf9dsF4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C3B1F000E9;
	Wed, 20 May 2026 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298022;
	bh=wFEC742dyig/NAAG6YkXpXrgJSfQe7o5/bOgBp7CO6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gf9dsF4OG5Uhu+eUG2zLuG7u40OJc6UE1n9kgMZH/v8E2irIc/7LforLPpxtgL9Ir
	 Vr9roGfXloPseA4U0dT/WPkWFcVPwjNIF5NgEmlx5vOjs15K2lKLLtZTAxvhkW4j4K
	 FE7HRTBf/JZp2xcC89gLjf4RlJPfAALoi3C9bHIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/957] PCI: Use res_to_dev_res() in reassign_resources_sorted()
Date: Wed, 20 May 2026 18:12:15 +0200
Message-ID: <20260520162140.007935408@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 4bee4fc0f4ee1086e498f9d197352237a0232598 ]

reassign_resources_sorted() contains a search loop for a particular
resource in the head list. res_to_dev_res() already implements the same
search so use it instead.

Drop unused found_match and dev_res variables.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251219174036.16738-9-ilpo.jarvinen@linux.intel.com
Stable-dep-of: 1ee4716a5a28 ("PCI: Fix premature removal from realloc_head list during resource assignment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index c2d640164f697..3ea6f3e726a8c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -417,7 +417,6 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 				      struct list_head *head)
 {
 	struct pci_dev_resource *add_res, *tmp;
-	struct pci_dev_resource *dev_res;
 	struct pci_dev *dev;
 	struct resource *res;
 	const char *res_name;
@@ -425,8 +424,6 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 	int idx;
 
 	list_for_each_entry_safe(add_res, tmp, realloc_head, list) {
-		bool found_match = false;
-
 		res = add_res->res;
 		dev = add_res->dev;
 		idx = pci_resource_num(dev, res);
@@ -440,13 +437,7 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 			goto out;
 
 		/* Skip this resource if not found in head list */
-		list_for_each_entry(dev_res, head, list) {
-			if (dev_res->res == res) {
-				found_match = true;
-				break;
-			}
-		}
-		if (!found_match) /* Just skip */
+		if (!res_to_dev_res(head, res))
 			continue;
 
 		res_name = pci_resource_name(dev, idx);
-- 
2.53.0



