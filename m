Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520773BED6A;
	Mon, 23 Mar 2026 15:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279391; cv=none; b=pMszFcCl0ipO7ZK5KQd8gOrKrf6kjuN+a+N5rQpua3sS+LqMYaUsjIqSinhKJGkc6sRTDqlq8mVJ7KVUonw6bZyBx+uvyJAF7N4UyzFYsuWTAUWFpkyHbUSRXSatik2TRfuRClQwcLFU8mYzmiZz7coXuMB2GG1jte2kg1epEJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279391; c=relaxed/simple;
	bh=MySTDoYkaE4J8MMA+8Ev2OeDzrtXj+8cc0f2CVlnuTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCTQ6eIqcpt/9K/P5OSjT5C+F7q91NSWJxiqWqZkP62rsGpaJpYxjkzIE/wnJdbYPfpPwjVOn5QGOSWsy2IgtiUAUbIgKW8hYJSDR/ffdHgFv4+Sq9tJAVqJP1U+dQRsBOAvFxvjyS9Ty1BYPnk9cu3VRq5B/Fr3pKAiOJmXCME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrULWul1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrULWul1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9325FC4CEF7;
	Mon, 23 Mar 2026 15:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279391;
	bh=MySTDoYkaE4J8MMA+8Ev2OeDzrtXj+8cc0f2CVlnuTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrULWul13GRZOR/iQ/jmlmHuILsRUER4+UmfdtE/qrMBEJG4p7rksdfouwBrjgQ5Z
	 y09sa2p4o5pFD//gWHNI2+Cmo5f8i+p40BVkYW/zeQ9YxD52t1oeCgQVBIeaS5RDbh
	 5AtNIk9BzSkjV/F0PMraxsku1m6IXOjqXVdXzhFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 554/567] i2c: fsi: Fix a potential leak in fsi_i2c_probe()
Date: Mon, 23 Mar 2026 14:47:54 +0100
Message-ID: <20260323134547.709294518@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit be627abcc0d5dbd5882873bd85fbc18aa3d189ed upstream.

In the commit in Fixes:, when the code has been updated to use an explicit
for loop, instead of for_each_available_child_of_node(), the assumption
that a reference to a device_node structure would be released at each
iteration has been broken.

Now, an explicit of_node_put() is needed to release the reference.

Fixes: 095561f476ab ("i2c: fsi: Create busses for all ports")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/fd805c39f8de51edf303856103d782138a1633c8.1772382022.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-fsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-fsi.c
+++ b/drivers/i2c/busses/i2c-fsi.c
@@ -728,6 +728,7 @@ static int fsi_i2c_probe(struct device *
 		rc = i2c_add_adapter(&port->adapter);
 		if (rc < 0) {
 			dev_err(dev, "Failed to register adapter: %d\n", rc);
+			of_node_put(np);
 			kfree(port);
 			continue;
 		}


