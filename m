Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DE1248BBB;
	Wed, 15 Jan 2025 10:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938799; cv=none; b=ZvuCQ6TLrEJJFVUy93gZCJZlZDTH0LUcQEWibdl+iS3GfWsfot6dsabRhXFXGDHShGlnMZxjTJFnC7UCbMgq8PCR1VholfRRa4X8oAIg0v+NMAfGvnBfnwCoguzVlniDB/KuxijcXZbW6BJ7cqKquFIskL3iX7PVVkelW//U0PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938799; c=relaxed/simple;
	bh=STCif33F+JMX5pxXV3hm9jGeMzXsI59t2qiOQ6ig3SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex/hlZsPi23ZAqicLNFc68QJ0A1smVSL6H3ehwJe8u2iZa8OzGMXcHPIkTww/w0XhJkX7K6eT4PCIMnZ7klaukReCf9Rm9+wg/Uozjk5hFNEVrMcxK769OwWbMBDEImlpUhKXpz6QnNOcgxmCxLZN0z+bWzDzpSoOt/dhlsu3rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKs5Ti4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKs5Ti4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5C5C4CEDF;
	Wed, 15 Jan 2025 10:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938799;
	bh=STCif33F+JMX5pxXV3hm9jGeMzXsI59t2qiOQ6ig3SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKs5Ti4BhBYH3tehthhIRXFwmgPxmlBMlPfhIuIDgamBQlYpU8up48MtFUuppR2IH
	 Az4oQPIEk/LiUif84hDl/f1ts5s7qBIBVNeUBpslPMwJchMZ/Cae+91099algEEXi7
	 pjz5DovQ0QYKAzzIhyni6hL4uvWAFiX0apdpE7Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ingo Rohloff <ingo.rohloff@lauterbach.com>
Subject: [PATCH 6.6 101/129] usb: gadget: configfs: Ignore trailing LF for user strings to cdev
Date: Wed, 15 Jan 2025 11:37:56 +0100
Message-ID: <20250115103558.385069228@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Rohloff <ingo.rohloff@lauterbach.com>

commit 9466545720e231fc02acd69b5f4e9138e09a26f6 upstream.

Since commit c033563220e0f7a8
("usb: gadget: configfs: Attach arbitrary strings to cdev")
a user can provide extra string descriptors to a USB gadget via configfs.

For "manufacturer", "product", "serialnumber", setting the string via
configfs ignores a trailing LF.

For the arbitrary strings the LF was not ignored.

This patch ignores a trailing LF to make this consistent with the existing
behavior for "manufacturer", ...  string descriptors.

Fixes: c033563220e0 ("usb: gadget: configfs: Attach arbitrary strings to cdev")
Cc: stable <stable@kernel.org>
Signed-off-by: Ingo Rohloff <ingo.rohloff@lauterbach.com>
Link: https://lore.kernel.org/r/20241212154114.29295-1-ingo.rohloff@lauterbach.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -824,11 +824,15 @@ static ssize_t gadget_string_s_store(str
 {
 	struct gadget_string *string = to_gadget_string(item);
 	int size = min(sizeof(string->string), len + 1);
+	ssize_t cpy_len;
 
 	if (len > USB_MAX_STRING_LEN)
 		return -EINVAL;
 
-	return strscpy(string->string, page, size);
+	cpy_len = strscpy(string->string, page, size);
+	if (cpy_len > 0 && string->string[cpy_len - 1] == '\n')
+		string->string[cpy_len - 1] = 0;
+	return len;
 }
 CONFIGFS_ATTR(gadget_string_, s);
 


