Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255914DD6FD;
	Tue, 21 Jul 2026 20:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667473; cv=none; b=VMlKX7jWvmVP9JoLhHZo94W8hdjzZkKmLvMVLdVg94uBPKEt/flnCX8iGsPGWdQs+NwHardh0ch3i54YdZD5fhBwLfQ9b/aJ42BfWS7uhjkrj9NL7GjuV1ZPE5bLTGr04zPtqgkBl5XTfigbhCcBYpCuEqX9aLwE3b9t7o26cM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667473; c=relaxed/simple;
	bh=fN7V+CNNKapEj0qT17gZZZrPMvWfg9ZvcrEx45U/CJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSNZ/DyTGN782p+kw8ZoRI+OTDYZZW5YGnEtXy9slRv8nbtkRIWwA3T56kS7JnHht/SqL5qaBxHB6Ad2kAFPbpFTs394dY6yx148MaYOwhYdNUfM7bUx5ukeHxWh0UxG/dIiVK6ysu2fns991tBn5iyP0/XSRVQ6wmm5uT07W2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/Xj6Vsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/Xj6Vsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7280F1F00A3D;
	Tue, 21 Jul 2026 20:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667463;
	bh=i/sZy6AP8Z9IEt63ZCp/f2j3HIqq665gUXa1ekYJDB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/Xj6VsiowG/C9Uf7vpzo7/K1qTFeeLTgN3JqCRwq0YoVtbKOmlODb4nIeYFQWpnO
	 x4HcdwbimYmkg0ta0rfJgvGi3xrfxEhy92GRBUa5VwfvwQ6hmP0YP1pEi2CzNUf63X
	 Jf120Uo8c4WJQ1/9taOCXiOjDNNBLqS7atYp3rTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 1072/1266] Input: ims-pcu - fix race condition in reset_device sysfs callback
Date: Tue, 21 Jul 2026 17:25:09 +0200
Message-ID: <20260721152505.806588244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 411b8c4b274737c3bf08e1e025801161603cfffc upstream.

The ims_pcu_reset_device() sysfs callback calls ims_pcu_execute_command()
without acquiring pcu->cmd_mutex. This can lead to data races and
corruption of the shared command buffer if triggered concurrently with
other commands.

Acquire pcu->cmd_mutex before calling ims_pcu_execute_command().

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1173,6 +1173,8 @@ static ssize_t ims_pcu_reset_device(stru
 
 	dev_info(pcu->dev, "Attempting to reset device\n");
 
+	guard(mutex)(&pcu->cmd_mutex);
+
 	error = ims_pcu_execute_command(pcu, PCU_RESET, &reset_byte, 1);
 	if (error) {
 		dev_info(pcu->dev,


