Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A252DC32D;
	Tue,  2 Sep 2025 13:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820134; cv=none; b=X88lXZ7D0IH1f82tUBpfga86s1mScVHT3rY57RaQCWPxioAQi5dYjZw+1aDGArvfbGej9tpv6v1ugZuY9h5iOY16TEWVzR8+8auNwdbPj1r+rmmCJfRdbmY7dnv9yhTv+lx9ZC+RzYPSEkGMzHGSwAdQn0ZiweorEQUfqCcRw04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820134; c=relaxed/simple;
	bh=mwmxNFGhtpsmFIy4e3DeXSqeSA6rSasAmm4Wx3gAVWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uV3/4sL3CpPCrd63YOznpLSaRoh7WWqWj2QcK/TQqtP9ghOZFwhN/YWerivAqOPxVc/N5Kk8k8PUMh+QykwD4XaYANZmHRlqBErzIUnkQqQ9fWVlaPRGh7etHIfVM15VCFEUe4h9k5g7isXObuue7hEtFhTZ+8hw/flxqtQs+UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKMSveIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKMSveIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521BCC4CEED;
	Tue,  2 Sep 2025 13:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820132;
	bh=mwmxNFGhtpsmFIy4e3DeXSqeSA6rSasAmm4Wx3gAVWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKMSveIexwybfjErJRRWzBaQ5kymNZ20MjwHiizY6AwjMHdHzIhaAJnjyahEV/YCd
	 1JE4eN1dzwtSgHbSJACA9ZSWkqW6uCHbiu7/w3DpW3N05Q2sEIu8YkzVoCJqcIdknm
	 p9zBFx3xiaD1KTJSymnDyKRdKkIrKpVlWW5b9lhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/75] of: dynamic: Fix memleak when of_pci_add_properties() failed
Date: Tue,  2 Sep 2025 15:20:13 +0200
Message-ID: <20250902131935.169542293@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit c81f6ce16785cc07ae81f53deb07b662ed0bb3a5 ]

When of_pci_add_properties() failed, of_changeset_destroy() is called to
free the changeset. And of_changeset_destroy() puts device tree node in
each entry but does not free property in the entry. This leads to memory
leak in the failure case.

In of_changeset_add_prop_helper(), add the property to the device tree node
deadprops list. Thus, the property will also be freed along with device
tree node.

Fixes: b544fc2b8606 ("of: dynamic: Add interfaces for creating device node dynamically")
Reported-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Closes: https://lore.kernel.org/all/aJms+YT8TnpzpCY8@lpieralisi/
Tested-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20250818152221.3685724-1-lizhi.hou@amd.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/dynamic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 4d57a4e341054..7f78fba502ec4 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -939,6 +939,9 @@ static int of_changeset_add_prop_helper(struct of_changeset *ocs,
 		kfree(new_pp);
 	}
 
+	new_pp->next = np->deadprops;
+	np->deadprops = new_pp;
+
 	return ret;
 }
 
-- 
2.50.1



