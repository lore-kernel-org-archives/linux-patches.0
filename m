Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25A64779A8;
	Tue, 16 Jun 2026 16:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627668; cv=none; b=ct/K6rw/4NfIal130M+3r7Sxxbfv1nqmI2xccXInCJEoNa1St2JT3KDnFJJlLu7QA0foJC+yTTdmjx91Nv4Frp060bXASnAcEAC4hiRVi3MRr2e6LMu2yMyMWgcdBeCw986L4x4cXMfSMURYLV+qS05AbCp31xFTtJacU/6iaWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627668; c=relaxed/simple;
	bh=B6440wugUa80IiZfQnR/2zUZHND8GP9iZqDe8MNxMyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NejdzGs04A3Bn5RGWmINvBzHiDZEcjXWEZqBoyiD1IrX9gSb4t10osYvgKndC9Rv0VGQ37X/rIH7CDvbfleVtmW5hapA86cu+Foh/F+179FoJc7e4KOBL/6h5Md/J4ahkkng6SBgmch471m9YCglSQiQLlEJbym8OMrUP4pWgx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVgI0g6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVgI0g6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E111F000E9;
	Tue, 16 Jun 2026 16:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627667;
	bh=A4ORgAXvyYfJ9qtXriZqDI1E2CWCEWot03MSaEiGnfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVgI0g6EI128ZZD6szYT+xxAtyLBiUalbYKF7uAYAfUvzEHmJMNInwqw1UEZ/ugpM
	 ijPEua6IgGSjFUpAby4VML2rgyyZyxska0q45nPo3hD8CP4VpRCsnLJsjjTMKNZCVY
	 igQG7aFjK+/iEZK8vZXe4ZuW/WuDYnY6ZlwD7ESg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 206/261] thunderbolt: Limit XDomain response copy to actual frame size
Date: Tue, 16 Jun 2026 20:30:44 +0530
Message-ID: <20260616145054.592903485@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 4db2bd2ed4785dbadaeeab9f4e346b21ac5fb8eb upstream.

tb_xdomain_copy() copies req->response_size bytes from the received
packet buffer regardless of the actual frame size.  When a short
response arrives, this reads past the valid frame data in the DMA
pool buffer into stale contents from previous transactions.

Use the minimum of frame size and expected response size for the
copy length.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -123,7 +123,9 @@ static bool tb_xdomain_match(const struc
 static bool tb_xdomain_copy(struct tb_cfg_request *req,
 			    const struct ctl_pkg *pkg)
 {
-	memcpy(req->response, pkg->buffer, req->response_size);
+	size_t len = min_t(size_t, pkg->frame.size, req->response_size);
+
+	memcpy(req->response, pkg->buffer, len);
 	req->result.err = 0;
 	return true;
 }


