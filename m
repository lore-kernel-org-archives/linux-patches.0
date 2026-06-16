Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C943CEBBD;
	Tue, 16 Jun 2026 18:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636289; cv=none; b=rXnAntN954ISWkV4jyjqvkytp/I0YZyGlXfUX+Ylz8PnzH5nRXiXIgbSfSJlr7m7jQmFrG3t7aJNH7oBYtG5M+iIfQErA7XCM0v6n7lpTiqXv6ClKSwtCUhdR0pS13bQGA7R9ClNIwDGcReLMxF7WTM1nVmQ8yOy9x+V4rP9PlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636289; c=relaxed/simple;
	bh=qHIyqINDzfjL3S5ey6477VHaVNB3UNg+9XWrZdjahf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuYI8CD1/Br/cSSQa9Rjl1HTb0yvG+3V88Zo4lPeM2isvXZyVetSYnbeG8UBh3owLUu5s/3hqrSqk/4EJYmH/CtKH1gSarq497AWtrOcbqANUFZ+AqfggGpcmnS59QiJ/CtR91vPaSw7o61qDrybSwMJRfxzOn6wqeuKejFFovI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFOlxK5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFOlxK5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50BC1F000E9;
	Tue, 16 Jun 2026 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636288;
	bh=H3JAv/3ckKYmTjrsahzGe1vhsKrWIi1qnxVEdiky6N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFOlxK5Qa0bR0J6R3HWlHdq4DK7ZcF19CyCaV+7nD56I8I3f+yPYu1R8DByePE416
	 LWI/mq5E64U+OsAbs1NRl8fLpeVGPI6rBO7Pm16vdEUsJQ572owIA5s7jepqun7ol1
	 FEEf/S7KPiXEbjw4Rg+TrzKzznRo3+yaR8DToiLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 210/342] thunderbolt: Limit XDomain response copy to actual frame size
Date: Tue, 16 Jun 2026 20:28:26 +0530
Message-ID: <20260616145057.957511207@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
@@ -81,7 +81,9 @@ static bool tb_xdomain_match(const struc
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


