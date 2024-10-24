Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD7C1FE107
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793398; cv=none; b=qzeZQrsnJckXcBmJipWG7zV9Bv0JKEZvmUyH3ygs0qdIYjIEaYKGhvWG4lYWxLIYlS0zeXigxvGPp7P16pq5nmSFcWEhOcNo1Xb31pZDDeHVzsP88ony/R8KjcWFz2s6Y3lZ8Kd3XNUDCoXoNV8GckWccu4YZzipFFCn3KX4ShE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793398; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyMxL3RdSZndfd0qB6mIs7V3CvlcIu/i4blnfmwYlwYZzUXDYKGe0SOWYdcQBitL5JBxWZv1KmL2Hvi8OPm3QQjiUcBUaf+hegEIzURlw/yewDsaqlwfI45SnP3FfgikHgT90eyNp4AtTDy+kjRdtk9LtdXFbWxLGe6LBLfpO0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ehCZ5fwv; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ehCZ5fwv"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539e690479cso1319776e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793395; x=1730398195; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ehCZ5fwv/LI252GDNMmTYEeY1x3y5rRd3oCxG8lQwKbt0cUG6GD8+mDlhs+uJ1huvQ
         M7qyXWi7nZfq9Fm0TBcb1xQIeQ6ekiT8G4uaC1clGRmjGoQ2xuiKN51yBX5eOD9slX/z
         W/qylcWaiyLHKpnNPXxprLikapnJ9K1vD7NRNSEojYgU6k4W1B7LK2NFGeekk9K0cauT
         zwV2JtzoIPna4c7AYb4WSg+s9l3gnCTopz0b6mxImm2RK3Z8YR6eUSrP4HSGk2cyJJPC
         +pBi5aHzNL8uVIp7yHSU8OF1rQaq4vPr5sNaBLyEe4YmldfP4bipYiEnbJrA1g0V8BOS
         E73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793395; x=1730398195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=S4UkcwasXagEc7xzJbuD6tZljK8GxRDDp4XPVaZjCrh51bG7sj/mB+Rx/ORTWb8Q1Z
         DUhkOs3WmQO+siBE44o8SrCKKgk9xFjyAH2hYTX41YCUhkZ+/2Mmzsmdbr+0v6V9I0e5
         VPBmt4XO/S5JK5gWIcxMAUYFqLRRlUL/79/0KZsTMxXUpSC+R0esr9VOaYGVb8rvGAUu
         61AAMcOpypRQl1Jau3fISJB1GHUdrVs6RtV3u+y/L5+KwneNxB01WjUaM1CF7nxUb5xo
         kf/02tixXPglX5dpfJ5NC1YHXG787+B0xDjGmWLhp7AJ8/EQlgAsIrSvEOlbQpM2UQgc
         U3+A==
X-Gm-Message-State: AOJu0YyeZLb16IesEIXT5n7Z3hI6XIai2dK2ZG9KRDqCh4ugrEi1c66c
	LdPu6wabdMPsslApzVTdqkcRt/RH047JFgriYvQyHoV0FktriiYg
X-Google-Smtp-Source: AGHT+IF5gokrVkft+lkcYr/FiYZZi0Av42Gu7ZeOShWOGpXh0ohY61NiHPy/FJpAsbXei8kfUk54Iw==
X-Received: by 2002:a05:6512:b16:b0:539:8a9a:4e63 with SMTP id 2adb3069b0e04-53b1a36ab08mr4336325e87.42.1729793394738;
        Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22442660sm1432934e87.297.2024.10.24.11.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:46 +0300
Message-ID: <20241024180946.4411-1-vladimirputin693389@gmail.com>
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
