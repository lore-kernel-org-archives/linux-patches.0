Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC5251A147;
	Thu, 17 Sep 2026 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666519; cv=none; b=a0XT8rvNSxO88B6BCC09JAKBig6g39oQBWEPkuD4/wspe8bdYlQv+HeZUq5fOrZ6ccDxip7vsJE+bDJqHhqI+2BGfvvC/sUYGjYbqWkGjdNIIx+ZNpZ5f6PTAagAgW3mCHHV4dbeyvwI4RGQ6F9FvkP0y+Ogahp5ZuoWyL7kqZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666519; c=relaxed/simple;
	bh=LAwIk14gnGkl6qUAxN1GDD2TW8vtZTA21A7BfqhBVxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLc3e6QG3REk/QL63EAYOzpg7glPDmunUKAGUw5fw8BkSo6N3CFY+2Ao78aS0smnxLXcch4a5y5aDI+C7E0LKfzQY+vIUlL0kKd2eQpBNlxK47mfwdiQHvQ5D/eD7PWqiTjutR26//Uw//esBcAilzRJLIsUeaF+BUypKJXsOzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zF0YGuu5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zF0YGuu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB6A1F000FF;
	Thu, 17 Sep 2026 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666518;
	bh=L3CirzjychxmmR94Ih+xbvzL0As6dPVONL9GUzCBto8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zF0YGuu5HntMaPj6FBcry7FS+VlOfYJSiqE1Tj3cIEWKjKC3Xp5DPQKNl966HBXVB
	 R8xI/0d7JVz0BQr5UcM9j4hvtt62d1zASjbjE1TNfQ4hPKvYgb8+B03wGJNVkER9co
	 E7891Ns1W1IciOFsLf89lmG5sUcDe3JiRqQ2TN9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.18 1025/1250] vdpa: ifcvf: Put device on unsupported feature error
Date: Thu, 17 Sep 2026 16:13:40 +0100
Message-ID: <20260917151619.840606365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiong Weimin <xiongweimin@kylinos.cn>

commit 4d470be71196ca0ce302e6623454533dc31b465b upstream.

Route unsupported provisioned features through the common error path after
vdpa_alloc_device() so the allocated device and adapter pointer are
released consistently.

Fixes: 46fc0917bbab ("vDPA/ifcvf: implement features provisioning")
Cc: stable@vger.kernel.org # v6.3+
Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <178589471294.1556376.4816776800128323034@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -724,7 +724,8 @@ static int ifcvf_vdpa_dev_add(struct vdp
 		if (config->device_features & ~device_features) {
 			IFCVF_ERR(pdev, "The provisioned features 0x%llx are not supported by this device with features 0x%llx\n",
 				  config->device_features, device_features);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err;
 		}
 		device_features &= config->device_features;
 	}


