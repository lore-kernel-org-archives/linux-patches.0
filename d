Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D5220012B
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793388; cv=none; b=aLNZ/RLytdUx3w5q68484Kik+aDgZFUYh8I4yVISm8HE1yiEUxhihw/67NAhplwUkplU9X383JpN7uPC1C2c4ncQgHeL83OOQSsuu5kGxidJLv73NQMc5UULfHWQfzov6QGXm6GvUD7My+euBBVkw+eWzZsqgyB/LCnLOinuh0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793388; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQ5T41wc9IoRWGA6iKkK4eYlO+qJubc0Lmc/LdElGoj3Ks8Ozq6xuQJZDPNqW4VMq0kTYILrXsxEnt2MyCTvITJHKLNfGFnBCe7VNyYu15JpcQLDOUEvbL5gDv2K3l4SAzTGjTETefznUQABExty1XKZFK0ULHZDFuzmwlM48wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d90T3X2k; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d90T3X2k"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fb3ce15172so21743651fa.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793384; x=1730398184; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=d90T3X2kbh0V70J8x4LpSYnKR0m7vKcVHxNCd4mpO83RUIZ0fAxJJVnpzTjmzQ3ESq
         TefKYmX4Uszt2DvE6Y7L9BwhPAWhOK7JMPht5adEyEO7I83koHVhjB0o4ly1oFl2wNW1
         sajPRTb/s+LQNLH/+l5pkVs145CVxNj2+nvZ1XQDgLFbgMtg9Razo7749Or91I8KB1Ii
         YnewczsBKlx+jAlj89Xs5Q1m6/wZQ1i3f3b1SBgAPMsv+K55HKVvEaHlVb2hOF4/kYGf
         Yu+oqmFV0Ot5Uz5GoySMQvTYOHnYLfe4oGGI9BshAnUe1MFtkh3NfvQY7irJ9jBQjLJj
         gG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793384; x=1730398184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=XBi1QPGUiKU33SCNWo43KplPCGz8m0og0InaA8skm7wGLFST8xbCGXjVNYWukPxjhq
         Soe+UfrjM0Izwm7i4UlHwdUML0uLl2F/KyVeBwIi0UFbn+rTliFnyAjmc9lAYEwe7F+X
         Jni499FVUguHwyKWO1ku4rjxJtiHGxe6jVe7UfcaqIlA6+yn6vXIwhj4iTSDxnNizX64
         d4zlAUS4Yqw86YJJfPSPDoXA9SWsXvwz4PEFJhYedK6V9qwjNXvBNjy2T4NuLxz8RifC
         Web90QF6sKhCQJJfI3lolpPnwFuLa9qQwHsQRbRq/pJhMb7RsXeop5poNkOfsRfbcJI3
         EqBQ==
X-Gm-Message-State: AOJu0YwM6QurWhz+MIXsmqWb3EDNbsN+6yMmFh9zbP911Tas90aCJzgz
	2iJ9r+9zEGBhwD8CANPMNDCjH0eAg3ClwVxTZZYgS3X2i8vXOpbKmfRKRc4e
X-Google-Smtp-Source: AGHT+IEv+nS9rB5kQJtgSgwT5Aqk2912uGjJVm4zI9qs0Hr9j7C7zku108JFu604nS6QF/NUz0cm2w==
X-Received: by 2002:a2e:b889:0:b0:2fb:6110:c5a6 with SMTP id 38308e7fff4ca-2fca8315914mr10069891fa.8.1729793384201;
        Thu, 24 Oct 2024 11:09:44 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad4b6f6sm14349341fa.8.2024.10.24.11.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:43 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3254-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
