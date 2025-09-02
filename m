Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEC0305062;
	Tue,  2 Sep 2025 13:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819894; cv=none; b=QCC/gDtWQVq5p1vMXar/qPbn4tdHJjaO1AGLk4bm7u10BGINW20D60kp9S6g1g9OfmitZiPC5uD621oMHSQi0n5ZcOBx2inoM0zty4IQUikyM7oGJqsQR4EIOpQ7UW4vthGt8rj3PZ/U42K4OMwHLufxHrh7nVYt27kxKq4tzJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819894; c=relaxed/simple;
	bh=rJJJI4Uc3MHTbNgz8SMOfQC5wtgueul78WD/Iah7Opc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETkFJouh00nc4DgAlfyM1t+6bACEWJA4h2yQxfN5zwZZCncHfiMcmjrkiB61wnSUY+808YuYwkqjJacvTKflt+mqSrIG0YepNDn73///UldzolSe3EcG+dPw9HHVamIsPPXCahWYep2+zpqmrGfhU2tdOChuY5w0QlNTS4gCZDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcsD/GRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcsD/GRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E39C4CEF4;
	Tue,  2 Sep 2025 13:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819893;
	bh=rJJJI4Uc3MHTbNgz8SMOfQC5wtgueul78WD/Iah7Opc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcsD/GRhGXOuK7x3J0SO90SI9bzFiSluaJIQWqNCisZT95jXn+YPlFfJUStVavVAz
	 QsroDLgf8xdArcfHTChV1oz1tEQ5r6NqHxLT0LPELc4nwl6rnWbmyqKOMYutUXXDl/
	 k+pW2Npz2KrdqDwhdzh8t6f8W5N12OcB/hFqxX/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 04/95] of: dynamic: Fix memleak when of_pci_add_properties() failed
Date: Tue,  2 Sep 2025 15:19:40 +0200
Message-ID: <20250902131939.780273661@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 110104a936d9c..fcaaadc2eca1d 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -938,6 +938,9 @@ static int of_changeset_add_prop_helper(struct of_changeset *ocs,
 	if (ret)
 		__of_prop_free(new_pp);
 
+	new_pp->next = np->deadprops;
+	np->deadprops = new_pp;
+
 	return ret;
 }
 
-- 
2.50.1



