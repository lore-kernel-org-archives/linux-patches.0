Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E478145FEB;
	Thu, 13 Jun 2024 12:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280503; cv=none; b=aNosSqKOOjaFX2n5t3ffSt9r0y0MyE1bQNEgyMtfgGU2N4yu6pG8XfT2muMwC2lyjULxoQfNl7GAKvmOUmBwoYC3HDA/sABRYnh9r3Mx4R6AKqTY+p6QJRociIlQeHrTxIA0fc2p5UUrr8f5g43rHbRL5hsj2xhDxJriu90/Ogs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280503; c=relaxed/simple;
	bh=iZOm9kwKttk5EHyom4VbTHsYEvTb/I9qrVybHLecmqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj6K0lP4Pu9emc51ECiWLkrjnS5Msdjs7dRHEEwY219GubCEzujYsvZ28iZZwL0hOh3SPnI4fLF9/3EKSmRmu0wk/kl6unyfJYaZjTUwAQrDZJ58wq+OkugyuED940iw0y3Va0dz2JNKOlkSA/+gcCwXmMluMLkL9uzpEtnkglE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OU/ZHA8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OU/ZHA8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC80FC4AF1A;
	Thu, 13 Jun 2024 12:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280503;
	bh=iZOm9kwKttk5EHyom4VbTHsYEvTb/I9qrVybHLecmqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU/ZHA8s5H+9fcAng4j5ChEZedizWn3AWWEFG0u5dFch9c1mvfwyePqVf9Zav9mJU
	 kGkhqzEdF8nfG7T9ZqXvUjCoxv5S0H65hWHXYuC3VeUV8p5srEeNZ1DFAzU4e0Ib+W
	 1rQW1+vmUHWC6qbpdbAoa/oR9Ej7uIBx4a0WzgfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 044/137] media: v4l: async: Properly re-initialise notifier entry in unregister
Date: Thu, 13 Jun 2024 13:33:44 +0200
Message-ID: <20240613113225.000291183@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 9537a8425a7a0222999d5839a0b394b1e8834b4a upstream.

The notifier_entry of a notifier is not re-initialised after unregistering
the notifier. This leads to dangling pointers being left there so use
list_del_init() to return the notifier_entry an empty list.

Fixes: b8ec754ae4c5 ("media: v4l: async: Set v4l2_device and subdev in async notifier init")
Cc: <stable@vger.kernel.org> # for 6.6 and later
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-async.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -639,7 +639,7 @@ __v4l2_async_nf_unregister(struct v4l2_a
 
 	v4l2_async_nf_unbind_all_subdevs(notifier);
 
-	list_del(&notifier->notifier_entry);
+	list_del_init(&notifier->notifier_entry);
 }
 
 void v4l2_async_nf_unregister(struct v4l2_async_notifier *notifier)


