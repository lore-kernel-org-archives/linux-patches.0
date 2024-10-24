Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682841FF7DA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793414; cv=none; b=JjZq2o/TNJd/wC5IIBVtEM/tegOP29pS9CrtA9hy3+4j1SctJv1bRcYGQnRkiVz9bSx3wzkTK5J3+VZ4gDtm7TlR2PR5ljEIHuwBPVPqMUhzOTpFUT6aNv1maguwpsAAP/+Av6Nlq7/CnAfdhNTSBdR90nDayWaa7oEH2ERdGBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793414; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U49TBAqfiwGSqrLUEb53DnFH1/UbrMQD7lnrAxiJVTJSY3ua68t6QbtiCNpgPoqgdmgqcL9AfkAEUcvfHONfw85YPQN6z2H8L4ahLJtYu7H/jekEC0nSyXLoQRlJGj4lzioaN1FavwlxiJkCLAH/Q770TCTiq1b5BjB3nnTER2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j72bj9v5; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j72bj9v5"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2fb599aac99so13095331fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793410; x=1730398210; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=j72bj9v5kJgMzR2MxB1gukIkFxhSuA7ODUDA4bVjEf8rcZ94EVYMLb4B4VgECJZF6w
         4kBTfO5bJROSd3E287CEib7gktDKFLmqza+O97TVRwtjGUuAUvg1mHhHIGJTlKlvjfTL
         ppgF5uE8ECms/UwLG8BYcnjW2kDE8qRdX1zCCuPboKuI4UTGqy4c8t3Avjb3JOzcF1kM
         PQDQWoxg4LAjCqgt4RRmIxsDiWdC1pMrprA2rZb/vfpqk1wvoZbE1WzUwYn314vAEUI3
         ttY7FOoKZ6Mbyg71j8nfozx3Tyo3PmsMYEyMG+reSsXXA6wgva0/phL76x74lzWiKFqn
         0PuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793410; x=1730398210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Gj9XHjBP4FBgI7qdHxsxXMKtTp56CGYKTFi7zMAGoIMcKLgxdSyKHF0lHDY4tRu96O
         lgFa0P/wqxkiV/8D6o+agkU3y+SVd/P1ISK/ghG4w3Q4EAQY3uDcvYc0vVx4cf3lLoJi
         lfw+mamMJerB1loUcUoF0qHlB1xlMXGreunb6RxgpD3fOEk7Iq8bCr9RdhyrRz75BIhI
         jOcjhlLblaxomwhBaBeoVlkkMIJUO6emLChg+IwIBgMXluf7/o6+ninj9wJm872QPJax
         O24pDqi/PanMBHv5fy1mJoFydr2sblKrgcgWphuK9LsxMfwMYUjiBEoiUpC2NEYG8rjO
         8RoA==
X-Gm-Message-State: AOJu0Yw67qzKfWRohtAmaMAAEr3kf8NWsQx0pv8yshsKJNWO035Ap/Fl
	6349/Li+xg0O0dARD7h2fDE4CtK2t5259qq5Pr2yPqeWAD0aFOJhnb7Fk30I
X-Google-Smtp-Source: AGHT+IFEvglvO/H5FEkY279uI761gLEImqbbt6ZDi16Q/oWmOeaccDEH0cr68+Xr2JpC9DnoD/bnog==
X-Received: by 2002:a2e:b6d2:0:b0:2fc:9622:794b with SMTP id 38308e7fff4ca-2fc9d36a879mr33806741fa.24.1729793410427;
        Thu, 24 Oct 2024 11:10:10 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae100c3sm14335371fa.109.2024.10.24.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6759-1-vladimirputin693389@gmail.com>
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
