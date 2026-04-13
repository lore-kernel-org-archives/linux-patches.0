Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152DC28B4FA;
	Mon, 13 Apr 2026 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097819; cv=none; b=PzfHpKWzgm850cBVWD0qKFHq+rKPN3GS9XBqnAVfhvDt8OizLTU56xGYaYxM63f8O4r5O2QTS+LTQIpxTE4FrSejM3mPvCuGdRBAiUbCMag/pIV5CPm2/NvFu1/MrJtYnm4n/uSXnFxJ7AZKoo/Y4ieqj7qPMjOKZeuUSEeqTzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097819; c=relaxed/simple;
	bh=uooornaEMvC1OuDX1M8U8vS+YQyhesf7qhAeeAFBP50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ls7jiRUk+s7rGiL5Pad9k+yEd9ahIF5eNwU8kiK29pLfJY4T1TlrXHbYCj7Lrrb9l0zU3DHTlzQe8adDYiXK6IIP0IRUX7nYZsjuSqw23IXvu1CXfKk+/t+coWreOorVH2YYFpxVZSfcdy8Ztc/ISG1mhWSgvcZ6VbVru/5oROQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYzd+I1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYzd+I1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F20EC2BCAF;
	Mon, 13 Apr 2026 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097819;
	bh=uooornaEMvC1OuDX1M8U8vS+YQyhesf7qhAeeAFBP50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYzd+I1xhak/6lx2B8BUmDjGTaqmnnkIA4YbxWOTdEzhO/ZzZ2gkuTySNXP+3ggQ9
	 Wi2NV8YVpbvnh1LHbR2h1uS713t/cUQV0CUnPJhUAfIQdBrBnN8wLsSRecPy0THIzm
	 AJIZH4AXt4FDxykTaqs/YwbEo+UNhmuAvmdoKbcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 284/570] i2c: fsi: Fix a potential leak in fsi_i2c_probe()
Date: Mon, 13 Apr 2026 17:56:55 +0200
Message-ID: <20260413155841.129673341@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


