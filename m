Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705EF8828
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC61EC4339B;
	Mon, 12 Jun 2023 10:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566587;
	bh=mVKv0RpQCiBwmFSYYHfHi1Q7cNJJj3WTXC75D3Whf+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWmP2zOAMoikBu1hcIw659PWX6f/ILYKTKYmU8NL3E/4n73C4wOm0WdFHB16G1jDQ
	 HI0jxYm8FZY5W+FwJs+C1rLT8nb2ui2TNRLF/qWAmDo1FIVSW+ub26p/G3NuZletXB
	 S5ALYX7Uy/zAV4YPZJeIYupj3fsCox9BCicqe9sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Hutterer <peter.hutterer@who-t.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 061/132] Input: fix open count when closing inhibited device
Date: Mon, 12 Jun 2023 12:26:35 +0200
Message-ID: <20230612101713.040655252@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 978134c4b192ed04ecf699be3e1b4d23b5d20457 upstream.

Because the kernel increments device's open count in input_open_device()
even if device is inhibited, the counter should always be decremented in
input_close_device() to keep it balanced.

Fixes: a181616487db ("Input: Add "inhibited" property")
Reviewed-by: Peter Hutterer <peter.hutterer@who-t.net>
Link: https://lore.kernel.org/r/ZFFz0xAdPNSL3PT7@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -701,7 +701,7 @@ void input_close_device(struct input_han
 
 	__input_release_device(handle);
 
-	if (!dev->inhibited && !--dev->users) {
+	if (!--dev->users && !dev->inhibited) {
 		if (dev->poller)
 			input_dev_poller_stop(dev->poller);
 		if (dev->close)


