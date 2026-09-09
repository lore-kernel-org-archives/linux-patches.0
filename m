Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFF3566C5B;
	Wed,  9 Sep 2026 14:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962752; cv=none; b=RqTuY6gIqfzpIliTcCBD8nsWG1Cy59Kc3nAXHz3Qq3v5Y4xbJtrSaFHU8qsmx1YE4lbsyB79Ap0i+sq0KOKyEuydzrnoolMRK1+lZVDgo7aOitz0RX2O5kHUw6LfD+ecnpt9UVozezgEhfVMSWL3y0PMAlb1i0DO3erL7l7TKn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962752; c=relaxed/simple;
	bh=WqFatK9gm6jVb1Ams+2wrXFAmBNR2PgPP6avY4DQzvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwoVU6WPN2I6C+/yxvUwta6S4x4iYP7i7h9BVFNVDZ243YEKGZcQsj+fMqporWU/GpF27uXq02FxBwGGnxLjWiQ0ck+NrxBs535cznxRWhEhPIo+AvyLvfikPkMU8KgxeB5YPqPJ7Ddpmjbvndn0xBfTcddj5hT2K/ZmccojsAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Je1YH4kG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Je1YH4kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AA71F00A3A;
	Wed,  9 Sep 2026 14:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962751;
	bh=OgDihdd0huGxpT22xHpi0F7gODR1GUJgMlk6Oc+72+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Je1YH4kGdELp+9Xm+epMI52X5+HwLUfHdanU8NVxi9Tf9mCDSewlCD7hxjXWNvYst
	 4VPGqmiHuy4IeDsTcdiUbd1kqICGjGN8G4wCHEeiqsXP1kqUmHXVq8tTc+ifRvI6zj
	 Jm3cvp8IGygDQp9KDcRy1pXKFo/EkUKaP8ohrAvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 400/556] media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link
Date: Wed,  9 Sep 2026 15:41:20 +0200
Message-ID: <20260909134244.708651030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

commit a6e86efd7f85e519bf48417f41923f8bd51f1597 upstream.

In v4l2_fwnode_parse_link(), the remote endpoint fwnode reference is
acquired using fwnode_graph_get_remote_endpoint(). This reference is
properly released in the error paths, but it is leaked on the success
path.

Add the missing fwnode_handle_put() before returning 0 to prevent the
reference leak.

Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Fixes: ca50c197bd96 ("[media] v4l: fwnode: Support generic fwnode for parsing standardised properties")
Cc: stable@vger.kernel.org
[Sakari Ailus: Fix subject prefix and coding style a little.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -633,6 +633,8 @@ int v4l2_fwnode_parse_link(struct fwnode
 	if (!link->remote_node)
 		goto err_put_remote_endpoint;
 
+	fwnode_handle_put(fwnode);
+
 	return 0;
 
 err_put_remote_endpoint:


