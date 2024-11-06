Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B3D1DF27C;
	Wed,  6 Nov 2024 12:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895523; cv=none; b=tzYWo8ozVvsi9LV9z5CA5k3gmXIOd2l8Ngk+DG3SIldtworYeZVdrG5uBoEnAUAiCb5+PJPDfTCgIIkK5fryczLRlelvAJGOpiW2NmXXIwoJiPmVe6k7UAyuAcyEMJIX1ryLgcyxpoE5sx17JT9ZLy4damFuN7/3NtP1Pe7/GAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895523; c=relaxed/simple;
	bh=4h1jDiHkwEGEa01tvs8hyqyAlAHRvSZlOhKUduQ8+fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoM2YLfZ122nr3d2kyMc583r9dkSVg1tqNgUlxi5WtHs5xePhec8K5SNBIWQLm+wkVkshipzc0PHXN3yq7SFusYnKhgj6RiCiKq50OiXw6pwAu4BUuNEEUTLbqOb0VSsAT9utLXjXgIx1bV0y3Lk0lZ0TWhd4raR6PoIn6J5qAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnLzn9+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnLzn9+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77DBC4CECD;
	Wed,  6 Nov 2024 12:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895523;
	bh=4h1jDiHkwEGEa01tvs8hyqyAlAHRvSZlOhKUduQ8+fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnLzn9+Cj1ChewpI2wXlLuTbHBHB4/KtM1UAgvIEVFAEcz4rMJyeTQQlJ80BVQsRy
	 ixnSTJ3NT9i/5k4+nCazkXqFdGXzytslwmCDiXzN3/TbcOmwgD+6u9A9+s/yJ2x3Q1
	 T6y94zbDuy341/QmP+2nkUfJ72J2QPmsn/MAFgdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 245/350] tools/iio: Add memory allocation failure check for trigger_name
Date: Wed,  6 Nov 2024 13:02:53 +0100
Message-ID: <20241106120326.986125197@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Jun <zhujun2@cmss.chinamobile.com>

[ Upstream commit 3c6b818b097dd6932859bcc3d6722a74ec5931c1 ]

Added a check to handle memory allocation failure for `trigger_name`
and return `-ENOMEM`.

Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
Link: https://patch.msgid.link/20240828093129.3040-1-zhujun2@cmss.chinamobile.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_generic_buffer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index ca9f33fa51c9f..e8cf3dc8de72c 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -483,6 +483,10 @@ int main(int argc, char **argv)
 			return -ENOMEM;
 		}
 		trigger_name = malloc(IIO_MAX_NAME_LENGTH);
+		if (!trigger_name) {
+			ret = -ENOMEM;
+			goto error;
+		}
 		ret = read_sysfs_string("name", trig_dev_name, trigger_name);
 		free(trig_dev_name);
 		if (ret < 0) {
-- 
2.43.0



