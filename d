Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45D92003CC
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793390; cv=none; b=YUwN/xUd0z2cqiuoJnKW00N6W0pjfej3BRYGrlUBJ60lbQjUtHTgM1Pb306l8srB6kYIMa3cj9S1pruVDVLHvg449aM07wnedTQ8/qyPklxw7opygi7+P2CcHPT7OaJ6D+FLO5j6p+R2YIQWWYOYR9KJYpYa+boHDYkux+m/zrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793390; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkrnreZIMUmuIv8CUoNQmdFd6FewDNT8OmbiIa/gqOzFhN/UpFWGJHTvmGLu/ZYkkP2Nh5+GO/uqa8Y758GKm2bI45bigkSx+Y1bivrKPc3ns+o9224R8+yOkiQU6pg0fc0eAivkpA4y5090FRkWyn2O49SjKEB0LL4bvAww4so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XCjqKnjC; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XCjqKnjC"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2fb584a8f81so12316521fa.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793387; x=1730398187; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=XCjqKnjCzXO+seGPDZ9OS3SYEdHzg/uVwwWX/bGSfONHrM51kOK728v1O0WPBiAb5f
         XlX1xUN+YKzpp/HLDBnEdsNE2QOUOk64DYXPmiESsd+nhmIAueRSwK+LNpn9BsPC3aJS
         8uNta3dRkqRCeVE1/sW4YQ48nesJ1fiZ8Un6evWRzyxZSZCyxhJ0pAdgkS+oTKYt9wVC
         8K4fZGwN2aeEGTqfkL22SoWjVkj/+4kAqsf2pxpdDVtTScbqTMQrIOin0Z7HCeNdg84e
         PGFt+Pyt0N4rEJEXybLR2PfljFXHRrx0O34j8tIwvS2bnXQaHAJA+uJpmD98wWiT14Cm
         dysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793387; x=1730398187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=D0rJzMt0IsQpv6qWSVa6FeXEPGyAjn78SlmT/Z4c40a7i+3bKekHTwxUXGFcxTMYn0
         vSigu4DOsGTVd5MqYvpAOcjPB8oy4ot7zQ4Vq4dHVTU62TIphW63aISiyOW2vvm3CYFR
         DB2vvVDakEP/QKOTylQx5cZZOU6uneE3oCCEAC4k7q2nl0LumgaE0qHFGRvHotRcvIS0
         7YeDj7k77PAf4O73/YxW7RZit1Vr8/NUblvTZTNM6nmafXNs5X09RQgQEetPh2d9QeU2
         caOyXWwWlbFgTdECiquUlBk9zSd9ClcmaZK1CX55zYn/kOTmS9IlHdyaVz4939B2TKuF
         GGHQ==
X-Gm-Message-State: AOJu0Yzj5TVgOOX15/Ipi/s42ssyUcWB+ZbehTgg4eLBbCiW1G/jo+pM
	FeqGVDR0zuKbwLz2FmzZ8RROqpz9CAierlwAuC0e1SGTap95KunC
X-Google-Smtp-Source: AGHT+IFEacq9iQvfv4k9935fdZ7SZetGjX5vVKurhPnagoVWqSOIs84reMgGlSJtsFK8XxuL4OxpOw==
X-Received: by 2002:a2e:a9a4:0:b0:2fb:2b5d:215d with SMTP id 38308e7fff4ca-2fca81c1cc1mr22043911fa.7.1729793387005;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9adf846esm14786851fa.81.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3290-1-vladimirputin693389@gmail.com>
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
