Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5DE3570AD;
	Mon, 18 Aug 2025 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526385; cv=none; b=Xa1E2gNf21yGN2hHVF4JOAKXmft97fWDDCy/jPBJLO4ddShR7C07Z1KebepPoN5iNDCMYpCOxaFaEpqkCST9RWl+RjWIj6ATC7EZDLRXzmLNVyimCWpEOf+f7STVCaENX8WW/uBAUZzErCheg4Cer6KSY4hHHTx3oxkVbo89sI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526385; c=relaxed/simple;
	bh=eBUvJ2OXiMlur/JMtlTKtiNAjZRuBJ6lQB9oZNzvGbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMZS0LFQ6Pr8qeP9DskU06yX5MRsg3pJjOtKSHmG1MWRN7Qs0f2TZYwZliaNf5+qmYc3qkz3iJ+n9zuZyBxgIU099ggTe3uLsZuQoV0hdALhc+jJK7kGJOP/US7s5Kp3+qcFIzDFni3YHKuXgk0wFqfvSlzdME4hResTAxa1/tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8WzTLyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8WzTLyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FA9C4CEEB;
	Mon, 18 Aug 2025 14:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526385;
	bh=eBUvJ2OXiMlur/JMtlTKtiNAjZRuBJ6lQB9oZNzvGbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8WzTLypNWTn1pT54Jl2ro8InEaPfpVya4aJvsU1AUEPxn9Gv1NrJfNWeugfMrG8i
	 DUAV2O/mgBFzZMtzfEvjxj953CK1Kjjk6m5sEa/F8LN62BSgGWCCQGLE6M4x5bibFu
	 dwo/h0pFe1i3jRZoPJPtgdwPDwMx677ApPGtfBWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.16 540/570] i2c: core: Fix double-free of fwnode in i2c_unregister_device()
Date: Mon, 18 Aug 2025 14:48:47 +0200
Message-ID: <20250818124526.681815204@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

commit 1c24e5fc0c7096e00c202a6a3e0c342c1afb47c2 upstream.

Before commit df6d7277e552 ("i2c: core: Do not dereference fwnode in struct
device"), i2c_unregister_device() only called fwnode_handle_put() on
of_node-s in the form of calling of_node_put(client->dev.of_node).

But after this commit the i2c_client's fwnode now unconditionally gets
fwnode_handle_put() on it.

When the i2c_client has no primary (ACPI / OF) fwnode but it does have
a software fwnode, the software-node will be the primary node and
fwnode_handle_put() will put() it.

But for the software fwnode device_remove_software_node() will also put()
it leading to a double free:

[   82.665598] ------------[ cut here ]------------
[   82.665609] refcount_t: underflow; use-after-free.
[   82.665808] WARNING: CPU: 3 PID: 1502 at lib/refcount.c:28 refcount_warn_saturate+0xba/0x11
...
[   82.666830] RIP: 0010:refcount_warn_saturate+0xba/0x110
...
[   82.666962]  <TASK>
[   82.666971]  i2c_unregister_device+0x60/0x90

Fix this by not calling fwnode_handle_put() when the primary fwnode is
a software-node.

Fixes: df6d7277e552 ("i2c: core: Do not dereference fwnode in struct device")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 2ad2b1838f0f..0849aa44952d 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1066,7 +1066,13 @@ void i2c_unregister_device(struct i2c_client *client)
 		of_node_clear_flag(to_of_node(fwnode), OF_POPULATED);
 	else if (is_acpi_device_node(fwnode))
 		acpi_device_clear_enumerated(to_acpi_device_node(fwnode));
-	fwnode_handle_put(fwnode);
+
+	/*
+	 * If the primary fwnode is a software node it is free-ed by
+	 * device_remove_software_node() below, avoid double-free.
+	 */
+	if (!is_software_node(fwnode))
+		fwnode_handle_put(fwnode);
 
 	device_remove_software_node(&client->dev);
 	device_unregister(&client->dev);
-- 
2.50.1



