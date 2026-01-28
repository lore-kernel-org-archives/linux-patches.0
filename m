Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7BD2F747F;
	Wed, 28 Jan 2026 15:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615184; cv=none; b=j4DwKAKGAMsTWQbmao98JVImvT/A3sqonbKyu/i2WlUtC9ky/hIreDGQQMfNB5yuByZDj56jiIuzb2veoTjgiRN4VNxwjUyZ77wH3ZQfqMe8Vp5WgRSh4uN1UPzwVw2IgwVQ3YHKy3Df3rk5b4SqtaWZwUzKzp4Hig8i7IzVOHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615184; c=relaxed/simple;
	bh=eT8fBgRyLUyMUO/7om/7IxIWZd20S33e6E3plbpu49Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1dQJdteg8NRP5Df/iX3xP9K3xSybfw0Y/xfA4CADPRSiAqT8abD+yd/uFnqdNruW1Ouho9XDMIfqOFsLCI0pkPehymbzLusU7QTZXG9YGs3pZhwNJ6CHvkdq5AL0KSDCFj3Rai36sknc/LPV1/Hrj8hJ5oozZWoAGFnF5D0Xes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnaoX1TI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnaoX1TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FD5C4CEF1;
	Wed, 28 Jan 2026 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615183;
	bh=eT8fBgRyLUyMUO/7om/7IxIWZd20S33e6E3plbpu49Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnaoX1TIVTXcShmw36ZZTQSrJZnBdmy8BkwP75lJTODaCOI+wHeo5NYAKz5MmV1xG
	 MsUh1t2JmNdPlWN2piO053/qcO8agsrbjUuVLCf0aKSclUFvbdjVEvPQsCIpuGdjhY
	 oA0SXINQDn8XZ6BEj33qzBiFSaQjuiNd+xs/GQNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 103/169] of: platform: Use default match table for /firmware
Date: Wed, 28 Jan 2026 16:23:06 +0100
Message-ID: <20260128145337.715126622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

commit 48e6a9c4a20870e09f85ff1a3628275d6bce31c0 upstream.

Calling of_platform_populate() without a match table will only populate
the immediate child nodes under /firmware. This is usually fine, but in
the case of something like a "simple-mfd" node such as
"raspberrypi,bcm2835-firmware", those child nodes will not be populated.
And subsequent calls won't work either because the /firmware node is
marked as processed already.

Switch the call to of_platform_default_populate() to solve this problem.
It should be a nop for existing cases.

Fixes: 3aa0582fdb82 ("of: platform: populate /firmware/ node from of_platform_default_populate_init()")
Cc: stable@vger.kernel.org
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://patch.msgid.link/20260114015158.692170-2-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -570,7 +570,7 @@ static int __init of_platform_default_po
 
 		node = of_find_node_by_path("/firmware");
 		if (node) {
-			of_platform_populate(node, NULL, NULL, NULL);
+			of_platform_default_populate(node, NULL, NULL);
 			of_node_put(node);
 		}
 


