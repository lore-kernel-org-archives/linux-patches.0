Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AA433372B;
	Fri,  9 Jan 2026 12:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962767; cv=none; b=NsIlKzCTPVKJ6NJz+NcnFRQyY8TbqYbOoeMTv+pGRSlXIVEyxOSFk25TJ8Hmwh9iQxP+A46fsB/zqURiKEuYUF4pvi3DMevwGVTdRjfuEGv9/GkNA5z8EYWnxd2nv/PRl4Rx9wV3HoBePqXDKgXwb1Tp4SXoPfxeuoQHXtJJu1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962767; c=relaxed/simple;
	bh=gQ+mljWJEO4nLAODSS+7Bqp6kML/bK982rnZPNaux3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLvXgBtf3AP3mBz85ej5U5iE1Hwt2V8yzgS5uBIaac9kcao706MImgLxpOPmnYTz4mTQzsPoMFxf5WwC8fjtAteeFqXeUakrTi2gZDmKi8wvFdZ7CLCririED927WjqtxZUxn6SKzDOojDCEaCnnILCozzM3iIQOgXzCINEf+F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0w6QBTbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0w6QBTbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93D9C4CEF1;
	Fri,  9 Jan 2026 12:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962767;
	bh=gQ+mljWJEO4nLAODSS+7Bqp6kML/bK982rnZPNaux3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0w6QBTbO6pxeoe3cHyi5i3qALERCVPlsYV8JrDaV9rb23odtk99Rc/aD8rLZW1tfe
	 6cAQIkE+h0PngH9ULaIUTO+DZhwGcRvUdR/z1W6omEry51SJahsOipF1bm0hOVBg+w
	 dpYMaNHKtEo3lzbRVCkKIu50n2mtASbI992qmjs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 480/634] media: renesas: rcar_drif: fix device node reference leak in rcar_drif_bond_enabled
Date: Fri,  9 Jan 2026 12:42:38 +0100
Message-ID: <20260109112135.608977295@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 445e1658894fd74eab7e53071fa16233887574ed upstream.

The function calls of_parse_phandle() which returns
a device node with an incremented reference count. When the bonded device
is not available, the function
returns NULL without releasing the reference, causing a reference leak.

Add of_node_put(np) to release the device node reference.
The of_node_put function handles NULL pointers.

Found through static analysis by reviewing the doc of of_parse_phandle()
and cross-checking its usage patterns across the codebase.

Fixes: 7625ee981af1 ("[media] media: platform: rcar_drif: Add DRIF support")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rcar_drif.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/renesas/rcar_drif.c
+++ b/drivers/media/platform/renesas/rcar_drif.c
@@ -1248,6 +1248,7 @@ static struct device_node *rcar_drif_bon
 	if (np && of_device_is_available(np))
 		return np;
 
+	of_node_put(np);
 	return NULL;
 }
 


