Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7203E1A0733;
	Tue, 30 Jul 2024 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359444; cv=none; b=Ik22cMyo22iqRlec7nrMwZYFvn9nY9vej4jehXfxRgpZWOyEk8PoANp2QjT1d/AOjJYFwu6kDHgPO8uctcBOespGv5dpbc5LXNiVXmxZyLZW/YrEsxvuuMQfY1RBk7AYcE6gHKi3G+HfaUe8tuwdr9i/AlJMfJnuynL2+ZVQmec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359444; c=relaxed/simple;
	bh=wyE/XZALZS/utTiOT+AuVPA/pzE32aisoZWQ3sYRJ9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzh+1tJxjWIjPEhe6oAVLGAbq3Hg55aVmuc/rUdnvfZe1kNQujgXMdO/OuK4W80mRBMckJkQ2LSzc5wfJb7X959oRa0l+phDG5SbiR2LAN0iTOYgwPz6CQsVd0gmNmqC0nXs/7lgbduSKtTLTzJ/UOXQlQW4R0zwa1TZp2tY8As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKSOnt9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKSOnt9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE77C32782;
	Tue, 30 Jul 2024 17:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359444;
	bh=wyE/XZALZS/utTiOT+AuVPA/pzE32aisoZWQ3sYRJ9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKSOnt9MkhUcjsnNjIAyj+n3I5aoUodRED7fuVhB9autiHez6eWsgKdvtGa+w8xil
	 cKSCrHhr86qBWheZ7pVHiJx8u4BQBlUtDtpRwJNjIEo1xngGCI/ViZPKhnZ4k3pj3E
	 IO0yT7UWd6ltw/w8S6u852EJuEw4Qw38JV+WemPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sean Anderson <sean.anderson@seco.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 483/568] rtc: abx80x: Fix return value of nvmem callback on read
Date: Tue, 30 Jul 2024 17:49:50 +0200
Message-ID: <20240730151658.905763513@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Joy Chakraborty <joychakr@google.com>

commit fc82336b50e7652530bc32caec80be0f8792513b upstream.

Read callbacks registered with nvmem core expect 0 to be returned on
success and a negative value to be returned on failure.

abx80x_nvmem_xfer() on read calls i2c_smbus_read_i2c_block_data() which
returns the number of bytes read on success as per its api description,
this return value is handled as an error and returned to nvmem even on
success.

Fix to handle all possible values that would be returned by
i2c_smbus_read_i2c_block_data().

Fixes: e90ff8ede777 ("rtc: abx80x: Add nvmem support")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20240613120750.1455209-1-joychakr@google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-abx80x.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -705,14 +705,18 @@ static int abx80x_nvmem_xfer(struct abx8
 		if (ret)
 			return ret;
 
-		if (write)
+		if (write) {
 			ret = i2c_smbus_write_i2c_block_data(priv->client, reg,
 							     len, val);
-		else
+			if (ret)
+				return ret;
+		} else {
 			ret = i2c_smbus_read_i2c_block_data(priv->client, reg,
 							    len, val);
-		if (ret)
-			return ret;
+			if (ret <= 0)
+				return ret ? ret : -EIO;
+			len = ret;
+		}
 
 		offset += len;
 		val += len;


