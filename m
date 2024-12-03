Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A1381ADA;
	Tue,  3 Dec 2024 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242443; cv=none; b=cM7+8LyC+FYLh0OIFclJe9WdME9h57g4+8QcF6RPny4tQ/DkkEEkACIGhMXmt3rTmvYa1M0AvRuWPXIDzFKltBoutvApoCaIow5eXU/ToJ8zvAnT2UMAg+pyixFwPg0Kl8ktbTa9mRP/QUtLvi5Y7d0ksMaACvvUKSNzjL6K638=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242443; c=relaxed/simple;
	bh=ShuYn0X10JdcVGjWiDJoBzOn2D2AN7faZxALcMBtL1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifrX1XCYqQ3apEXDvG3NyyWKBXw2dIknarftyhmLGEXbbUJHIy9pQe5/dUTbqim4xLF4xJKnaJKJ5+Aurji4nXTs88+JpwR6cZcEU19JwCPc+mWdt3y2pPgVQMXstjZTfdCUxc24fjr1mA1NOxeqctn/UAhExVjkdckBksE7/e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqYbNock; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqYbNock"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA64C4CECF;
	Tue,  3 Dec 2024 16:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242443;
	bh=ShuYn0X10JdcVGjWiDJoBzOn2D2AN7faZxALcMBtL1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqYbNockRMRuBzIZM6+51MWMzC7FjFhPeCJEujJUGfu0YrSPHE0FIMUXMstNYTENU
	 2i/bNDO0TQ1h1vbHDiqp+2kJihpEkJpvobtu+0v7HUzJcPPp0YaJVwzmNhflFzL+ic
	 PNWUOsavdkIXzt6olgJreq5uonBsBuztksW3YFVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.12 705/826] platform/chrome: cros_ec_typec: fix missing fwnode reference decrement
Date: Tue,  3 Dec 2024 15:47:12 +0100
Message-ID: <20241203144811.260605789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 9c41f371457bd9a24874e3c7934d9745e87fbc58 upstream.

The device_for_each_child_node() macro requires explicit calls to
fwnode_handle_put() upon early exits (return, break, goto) to decrement
the fwnode's refcount, and avoid levaing a node reference behind.

Add the missing fwnode_handle_put() after the common label for all error
paths.

Cc: stable@vger.kernel.org
Fixes: fdc6b21e2444 ("platform/chrome: Add Type C connector class driver")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241013-cross_ec_typec_fwnode_handle_put-v2-1-9182b2cd7767@gmail.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_typec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -409,6 +409,7 @@ static int cros_typec_init_ports(struct
 	return 0;
 
 unregister_ports:
+	fwnode_handle_put(fwnode);
 	cros_unregister_ports(typec);
 	return ret;
 }


