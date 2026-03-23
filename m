Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE013245020;
	Mon, 23 Mar 2026 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278449; cv=none; b=Y4TzGSA0ZxLd/4Q6HJRK3qI1GoBt/iK0A/R8QVO7rBoFOYy5HQUUfjQa9x4F687ioX3U6NngNpXXrg72LMynIklOGB1lpNACS1/NpJduYU5kNOZeT3OvFnMmnorqJ/ngqADKtFUp2M0FXamHMYa0atAKz9fb0AqU32n1l5q0tqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278449; c=relaxed/simple;
	bh=MssYNBAMJOYf7zDcOhePiWbKw2rFr61KHtUWYgMK8/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj1fSqqY/WRhggm/Hzj+VetlkjNrSHP+rZryV2mp+l0XJD0L4RGP9YeJ4HMmAzVEJCwme6TDGvq+5eRBrsfOLjV+ATVD097Ezm3JpZWGXz4IufUK+BbI9xffC9Ud+wfN3VAY9tmjTbaTBeiaUkiS2ugG84/hMiASZ0lhRLhK2j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxDs7oNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxDs7oNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32956C2BCB1;
	Mon, 23 Mar 2026 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278449;
	bh=MssYNBAMJOYf7zDcOhePiWbKw2rFr61KHtUWYgMK8/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxDs7oNdyAY/nBvLkoe8V1KZOhrJggzOY9SkAfeKPUkRhUAcM7ZFnNuEDAM5ghH8A
	 cdZuV7kMEw8JFotJJusxXw1FM1CS3c6yfjBupBVzpFB5EU0Htp847u/AV2CIpCSNOS
	 HkrBvaNSJDiFsNBdsc8hqmMCLJ9kXX3tVz6NmYJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 310/567] device property: Allow secondary lookup in fwnode_get_next_child_node()
Date: Mon, 23 Mar 2026 14:43:50 +0100
Message-ID: <20260323134541.494077997@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 2692c614f8f05929d692b3dbfd3faef1f00fbaf0 upstream.

When device_get_child_node_count() got split to the fwnode and device
respective APIs, the fwnode didn't inherit the ability to traverse over
the secondary fwnode. Hence any user, that switches from device to fwnode
API misses this feature. In particular, this was revealed by the commit
1490cbb9dbfd ("device property: Split fwnode_get_child_node_count()")
that effectively broke the GPIO enumeration on Intel Galileo boards.
Fix this by moving the secondary lookup from device to fwnode API.

Note, in general no device_*() API should go into the depth of the fwnode
implementation.

Fixes: 114dbb4fa7c4 ("drivers property: When no children in primary, try secondary")
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/20260210135822.47335-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -750,7 +750,18 @@ struct fwnode_handle *
 fwnode_get_next_child_node(const struct fwnode_handle *fwnode,
 			   struct fwnode_handle *child)
 {
-	return fwnode_call_ptr_op(fwnode, get_next_child_node, child);
+	struct fwnode_handle *next;
+
+	if (IS_ERR_OR_NULL(fwnode))
+		return NULL;
+
+	/* Try to find a child in primary fwnode */
+	next = fwnode_call_ptr_op(fwnode, get_next_child_node, child);
+	if (next)
+		return next;
+
+	/* When no more children in primary, continue with secondary */
+	return fwnode_call_ptr_op(fwnode->secondary, get_next_child_node, child);
 }
 EXPORT_SYMBOL_GPL(fwnode_get_next_child_node);
 
@@ -794,19 +805,7 @@ EXPORT_SYMBOL_GPL(fwnode_get_next_availa
 struct fwnode_handle *device_get_next_child_node(const struct device *dev,
 						 struct fwnode_handle *child)
 {
-	const struct fwnode_handle *fwnode = dev_fwnode(dev);
-	struct fwnode_handle *next;
-
-	if (IS_ERR_OR_NULL(fwnode))
-		return NULL;
-
-	/* Try to find a child in primary fwnode */
-	next = fwnode_get_next_child_node(fwnode, child);
-	if (next)
-		return next;
-
-	/* When no more children in primary, continue with secondary */
-	return fwnode_get_next_child_node(fwnode->secondary, child);
+	return fwnode_get_next_child_node(dev_fwnode(dev), child);
 }
 EXPORT_SYMBOL_GPL(device_get_next_child_node);
 


