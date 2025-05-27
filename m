Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62CC1CAA7B;
	Tue, 27 May 2025 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367642; cv=none; b=dtrV53XQDGsAmECYFRniYEb0qK193I/uOXcOYaCqiKygaXxJ2kbVN99fu4Mi3XmA1aBVHvqjnUcBwThtkkXkPgVrKm8/89w0J9r4R11AVtSqfrq/Pw1dvXIIvTeIktZrPltenqTbRB74uUxAL/WF1k+EJvGPPvLlnMGGxqb6igc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367642; c=relaxed/simple;
	bh=bqvJsNnxE+8GlKGqfCoeRmFYcZKnPZtTIP6eKuKZES4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0HGTEltAqP+nC0Gp3kAepPV/yXPFd7gGlUHm/sdo18lnLZT3bR+n1OjRav7ceXQmoF7XOVtZBo6JvTylmYF930IqKN1YvMfPgzIU1KoG0Ph6oK64yAAGHVciJ3HSKk08H/fNk8cuNK3v7s5dFXl1EoxQ7zKK45yV5yLhCptjXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goSv1eOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goSv1eOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F089C4CEE9;
	Tue, 27 May 2025 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367642;
	bh=bqvJsNnxE+8GlKGqfCoeRmFYcZKnPZtTIP6eKuKZES4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goSv1eObuz0bOzbvMmcTtA+urCuVn4Q73nS42fV1iWxMLre/FRaLFnMWesMb8ouUM
	 WrMQR+a/Nn78OHZJfay7Udo8DLohOatfmcOkfZBtIVkuXBi5vnp74AOjZyn0OlHeJO
	 Ilo5hfjeOok3C02pAwYtVZMXEXUK/QONN56CiqOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 453/783] media: i2c: ov2740: Free control handler on error path
Date: Tue, 27 May 2025 18:24:10 +0200
Message-ID: <20250527162531.572662842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 71dfb2c7548994aad6cb0a316c2601e7144d15a5 ]

The control handler wasn't freed if v4l2_fwnode_device_parse() failed. Do
that now.

Co-developed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2740.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2740.c b/drivers/media/i2c/ov2740.c
index 9a5d118b87b01..04e93618f408a 100644
--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -828,8 +828,10 @@ static int ov2740_init_controls(struct ov2740 *ov2740)
 				     0, 0, ov2740_test_pattern_menu);
 
 	ret = v4l2_fwnode_device_parse(&client->dev, &props);
-	if (ret)
+	if (ret) {
+		v4l2_ctrl_handler_free(ctrl_hdlr);
 		return ret;
+	}
 
 	v4l2_ctrl_new_fwnode_properties(ctrl_hdlr, &ov2740_ctrl_ops, &props);
 
-- 
2.39.5



