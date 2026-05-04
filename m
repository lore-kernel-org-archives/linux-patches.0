Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAC53E1223;
	Mon,  4 May 2026 14:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904721; cv=none; b=EvlWJspmpB9moHBAh0ew181jbKLUrPxGFv26Zfi5/Q/ijW+YZBIpqGNzqf233GoUldaz+w7+XiD1YMojRZ61r29b0n4MbX+mvbXKbMzqliZ75mrrA0ifwyqHewLZ+WrRaerfjMu7QQ+M2uJPUDHbbxlgCEag9jHefLjR7lVhjKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904721; c=relaxed/simple;
	bh=W1dUxmuNK9urUhrUb6VhEaTZVl3O2VTaqZUZ74ntlMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyQuaOnz0Ggjz5GOBe6UH+FKI1EtbV6tPiMKpkE3S+16CfuovJG9HTZQw8DZNijY2xL493xtuZeuV9hGQfiV+umPmLOtVnBVLO+dujGoeRBP0TIHm+3dvtppwLEvdDJ4pcsAcfeob5b5FyLahzUPqBGQhHs+NkIItVTwlvKmwL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BP9Z8zPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BP9Z8zPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E95C2BCB8;
	Mon,  4 May 2026 14:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904721;
	bh=W1dUxmuNK9urUhrUb6VhEaTZVl3O2VTaqZUZ74ntlMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP9Z8zPy+t38Ab7nUbEL83m6uqZh6Wt9OjOJTvJXLmjAHXXpFsjxVxTa4zXCv1hgO
	 siGXeBKqj6cG5wm915alIrNbs3YGciIlDArjyJsvtiHw6eKp8+GTo9oNPO3d5EDJif
	 yf4kQ3tieAqB5GO/IAf95YbYjoyT6i7y16TW7zLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Mak <makb@juniper.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 149/215] mfd: core: Preserve OF node when ACPI handle is present
Date: Mon,  4 May 2026 15:52:48 +0200
Message-ID: <20260504135135.611250232@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Mak <makb@juniper.net>

commit caa5a5d44d8ae4fd13b744857d66c9313b712d1f upstream.

Switch device_set_node to set_primary_fwnode, so that the ACPI fwnode
does not overwrite the of_node with NULL.

This allows MFD children with both OF nodes and ACPI handles to have OF
nodes again.

Cc: stable@vger.kernel.org
Fixes: 51e3b257099d ("mfd: core: Make use of device_set_node()")
Signed-off-by: Brian Mak <makb@juniper.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260325223024.35992-1-makb@juniper.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/mfd-core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 6be58eb5a746..7aa32b90cf1e 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -88,7 +88,17 @@ static void mfd_acpi_add_device(const struct mfd_cell *cell,
 		}
 	}
 
-	device_set_node(&pdev->dev, acpi_fwnode_handle(adev ?: parent));
+	/*
+	 * NOTE: The fwnode design doesn't allow proper stacking/sharing. This
+	 * should eventually turn into a device fwnode API call that will allow
+	 * prepending to a list of fwnodes (with ACPI taking precedence).
+	 *
+	 * set_primary_fwnode() is used here, instead of device_set_node(), as
+	 * device_set_node() will overwrite the existing fwnode, which may be an
+	 * OF node that was populated earlier. To support a use case where ACPI
+	 * and OF is used in conjunction, we call set_primary_fwnode() instead.
+	 */
+	set_primary_fwnode(&pdev->dev, acpi_fwnode_handle(adev ?: parent));
 }
 #else
 static inline void mfd_acpi_add_device(const struct mfd_cell *cell,
-- 
2.54.0



