Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F787336881;
	Mon, 13 Apr 2026 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099806; cv=none; b=n2py1sWy2UDy60Ad1kmv4KHlyryfYaqSG2KH5uMp6QpT7XBPN2hnPva8DHabbqUovWI97GBbEZuD4y6diBhMOk9y5zK1JC0IboY6zCFfQGEZXYw9H7CTQPom3zxwOYVpXWEOStgNkaMNIxYe4w3XBzwDHHzKlQu2vGwQOlbbNSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099806; c=relaxed/simple;
	bh=KyOBt7nUzqdbiXtBdYZpYZocBOBilPEhQujTGKjjURM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEA0E/VKSfzUxDxl6+fNBTq65wVmQi+4GlZc4hOJGo4yaurCMtiNXoXbLS0f1z5ADcpT8ymvRF/fFmlqHvKWWexh3pJKubAq+3Mzu4pC7YY4IFvSxKhOeMmlJAOifr+oz4hapY4p8v3OWquoYAze2K0qTOAH88mrrRXlK4jHSTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWWXKuST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWWXKuST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5D6C2BCAF;
	Mon, 13 Apr 2026 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099806;
	bh=KyOBt7nUzqdbiXtBdYZpYZocBOBilPEhQujTGKjjURM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWWXKuSTB9vPgK2KNPVbL5AwGdSDmo/rpOW6WsTmUjBr339XkR24IHR6Mb6aT8D0O
	 a+GALBYziJVqcxmdXeeOwmO0ASMNV1ZmqSQ+zqgxZ7LptzlvLiG99Frfh+iC8VlI0j
	 MqG2OskhI/9ljChS4bNUhg5WSZJEdAH/TC5q5J1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 481/491] device property: Retrieve fwnode from of_node via accessor
Date: Mon, 13 Apr 2026 18:02:06 +0200
Message-ID: <20260413155837.059968617@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 3cd8015040d7537a6b88e26f36768a90d9247829 ]

OF provides a specific accessor to retrieve fwnode handle.
Use it instead of direct dereferencing.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 2692c614f8f0 ("device property: Allow secondary lookup in fwnode_get_next_child_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -21,7 +21,7 @@
 struct fwnode_handle *dev_fwnode(const struct device *dev)
 {
 	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
-		&dev->of_node->fwnode : dev->fwnode;
+		of_fwnode_handle(dev->of_node) : dev->fwnode;
 }
 EXPORT_SYMBOL_GPL(dev_fwnode);
 
@@ -763,7 +763,7 @@ struct fwnode_handle *device_get_next_ch
 	struct fwnode_handle *fwnode = NULL, *next;
 
 	if (dev->of_node)
-		fwnode = &dev->of_node->fwnode;
+		fwnode = of_fwnode_handle(dev->of_node);
 	else if (adev)
 		fwnode = acpi_fwnode_handle(adev);
 


