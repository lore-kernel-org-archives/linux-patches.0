Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38C91917D2;
	Tue, 10 Sep 2024 10:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962624; cv=none; b=l44dZ+sgQPj9y28UaGu/IQ1LKQfD3rhgQfIeEIx1mHCHKuInFdad9MgXVWCR9KsxhIptTuyjloVNB09KPUGQMn6ax8/8cTYQU0k86fUgv98GHOI45I9AYA9eh7sXrXYmiPhYD2lsm5voqvRMEcx7HZV8sqrfuiC+IC7UwZGlNpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962624; c=relaxed/simple;
	bh=ycd+bECLST7H+QJKpu95eZ0FkDpGofvYWw/KixkTF1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ww/chWRE9I0GuHscZ7wANiViKbZDyVmugieWGnR6LBUqlgFFx9H67JV6zEnpPKylwVsl5SRtiqgmLdUC55zwf6wGSXxXTqEivacJSaR540NPOcRmFxY2C6WfyDKlvfZa/GJDP4TxgBlt1yQK1E0RltgO8FCpt6gXVqa413YwVBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8pz3GWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8pz3GWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E934BC4CECD;
	Tue, 10 Sep 2024 10:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962624;
	bh=ycd+bECLST7H+QJKpu95eZ0FkDpGofvYWw/KixkTF1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8pz3GWrj0Wtr4+QTK/mhJTAzpzYaKT4tG7b+sGNGLD6cuWMkKc2xlxkG7Z8WF+d1
	 KUj8GLq0MNheTPN0Mk5o4/ax3hfyXetvEaGK7Tx8dSHCn820p6roHp57UpnZeiHYqt
	 keu5mTOY/vCe1FgMpG26eG8fH9ye3GTlmhh+YLdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Martelli <matteomartelli3@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 097/121] iio: fix scale application in iio_convert_raw_to_processed_unlocked
Date: Tue, 10 Sep 2024 11:32:52 +0200
Message-ID: <20240910092550.443571754@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matteo Martelli <matteomartelli3@gmail.com>

commit 8a3dcc970dc57b358c8db2702447bf0af4e0d83a upstream.

When the scale_type is IIO_VAL_INT_PLUS_MICRO or IIO_VAL_INT_PLUS_NANO
the scale passed as argument is only applied to the fractional part of
the value. Fix it by also multiplying the integer part by the scale
provided.

Fixes: 48e44ce0f881 ("iio:inkern: Add function to read the processed value")
Signed-off-by: Matteo Martelli <matteomartelli3@gmail.com>
Link: https://patch.msgid.link/20240730-iio-fix-scale-v1-1-6246638c8daa@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -637,17 +637,17 @@ static int iio_convert_raw_to_processed_
 		break;
 	case IIO_VAL_INT_PLUS_MICRO:
 		if (scale_val2 < 0)
-			*processed = -raw64 * scale_val;
+			*processed = -raw64 * scale_val * scale;
 		else
-			*processed = raw64 * scale_val;
+			*processed = raw64 * scale_val * scale;
 		*processed += div_s64(raw64 * (s64)scale_val2 * scale,
 				      1000000LL);
 		break;
 	case IIO_VAL_INT_PLUS_NANO:
 		if (scale_val2 < 0)
-			*processed = -raw64 * scale_val;
+			*processed = -raw64 * scale_val * scale;
 		else
-			*processed = raw64 * scale_val;
+			*processed = raw64 * scale_val * scale;
 		*processed += div_s64(raw64 * (s64)scale_val2 * scale,
 				      1000000000LL);
 		break;


