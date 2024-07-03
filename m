Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285EA17279B;
	Wed,  3 Jul 2024 10:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003917; cv=none; b=NlNmK/FnkZ942jh2VuY+4luxO8o1Gr4JBnDsyUseLpjzvZQZVZNRmnrOzQyamc68w5xRBW7DNwG7MTz5xKZpuDw84LwT10bFg4x3F0KL1bHB1rg7YDZrFY9WJlxY5VMwrIIwbmhinHGQ3GGS/H2wulx5zeHx6lcxPXhewxhOc8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003917; c=relaxed/simple;
	bh=PqFR/4uDl8jwtr5GpxhnY8nbX/yeeqrBDDzI/hSYjwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uzPbALguicO7kLP1yTbeCM7VTnHHTqQby+IEvT5sxBnQqMHa9DxauFKO9TbJkfccd8gRew/UUYiJOq5TXaNSGqzdhf091DBu/fJYewam2Z50m/LaAPAX8GSpmcL4cYxLTOVi8xqQlMUfNTgGQdzurPsEZabz5uh3Prva+3x5Vrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulfr8eCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulfr8eCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0688C2BD10;
	Wed,  3 Jul 2024 10:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003917;
	bh=PqFR/4uDl8jwtr5GpxhnY8nbX/yeeqrBDDzI/hSYjwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulfr8eClU5jfR0IcE4SosUwL9j0T6ccFCfBlMcf/ntcxyh6TBhP3Ahn5P/HajIq9s
	 SAk+F7jMN1ZDpCJCE9BSBEe7rhEAgNii6wlSPL5OwvwQgJgBTRb1glSZwcmXtvueAe
	 Tnp4WOY0EDC2BeKzVPYGzSQSap9HfjzCZLnVzIRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/189] HID: logitech-dj: Fix memory leak in logi_dj_recv_switch_to_dj_mode()
Date: Wed,  3 Jul 2024 12:38:37 +0200
Message-ID: <20240703102843.625881426@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit ce3af2ee95170b7d9e15fff6e500d67deab1e7b3 ]

Fix a memory leak on logi_dj_recv_send_report() error path.

Fixes: 6f20d3261265 ("HID: logitech-dj: Fix error handling in logi_dj_recv_switch_to_dj_mode()")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 0c2aa9024b878..be19f299f9ec8 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1213,8 +1213,10 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 		 */
 		msleep(50);
 
-		if (retval)
+		if (retval) {
+			kfree(dj_report);
 			return retval;
+		}
 	}
 
 	/*
-- 
2.43.0



