Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9331B195FEC;
	Mon, 21 Oct 2024 10:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507648; cv=none; b=dDNQrVqxSeewHiMPkANcZod2+JQIQTj0QpB90OtPDZXu7+zSWi+8onZ8iOzt5FdXBO3jw9P9o3WyijxbgFHpP2PFv1T4ZLCrjS/seahvT4enLiqDfmzFpiejPDnQ8C9kHi7U2GV6a1Ztx+jnGo44ogmfXlTA7Wa/gQxOmTlFoj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507648; c=relaxed/simple;
	bh=Lwc7WdVb6xdZhdvDITW1zxrqiQvxfa2+3xRp8QputIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxsOAPX4AVNyt6MqmlbDTPDMaE/U7OKGfKGAsG7coItVC7LyUj27TS9TD0775C6DMRb8hmeKOgGVP98ye3kErP7I+5145fcbuJOEXKv9rv4luehgafRMciI8a2PYPev5EBZIZ0Alai11I1ARXPwL91fYREPkuADWADHHjTa1utA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9WXh+NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9WXh+NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111FDC4CEC3;
	Mon, 21 Oct 2024 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507648;
	bh=Lwc7WdVb6xdZhdvDITW1zxrqiQvxfa2+3xRp8QputIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9WXh+NGQ5eIABDDsEGZXGoHMiETJmyakQT7jU44oX78z31O16s47pmW9dioFWrVf
	 xkNM38H3XRo7r6/v8p3SVaGJ3mpW2Pz6TOYAKuv3uU0zlQB7VOGkT2MVQp14ROZxWs
	 KRYBzOSOnV1q+WxoQECkkED41NsHv3UyJY+gVJgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 56/82] iio: light: veml6030: fix ALS sensor resolution
Date: Mon, 21 Oct 2024 12:25:37 +0200
Message-ID: <20241021102249.447095364@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit c9e9746f275c45108f2b0633a4855d65d9ae0736 upstream.

The driver still uses the sensor resolution provided in the datasheet
until Rev. 1.6, 28-Apr-2022, which was updated with Rev 1.7,
28-Nov-2023. The original ambient light resolution has been updated from
0.0036 lx/ct to 0.0042 lx/ct, which is the value that can be found in
the current device datasheet.

Update the default resolution for IT = 100 ms and GAIN = 1/8 from the
original 4608 mlux/cnt to the current value from the "Resolution and
maximum detection range" table (Application Note 84367, page 5), 5376
mlux/cnt.

Cc: <stable@vger.kernel.org>
Fixes: 7b779f573c48 ("iio: light: add driver for veml6030 ambient light sensor")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20240923-veml6035-v2-1-58c72a0df31c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6030.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/veml6030.c
+++ b/drivers/iio/light/veml6030.c
@@ -780,7 +780,7 @@ static int veml6030_hw_init(struct iio_d
 
 	/* Cache currently active measurement parameters */
 	data->cur_gain = 3;
-	data->cur_resolution = 4608;
+	data->cur_resolution = 5376;
 	data->cur_integration_time = 3;
 
 	return ret;


