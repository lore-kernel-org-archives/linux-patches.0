Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034F21FC7F6
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793398; cv=none; b=Fm5EWY39E58JVTPYyLpY3zuW5wjKomvXfASQ2yW8Wtibl6KRD8XhesuqGSOtPw5gXykseCJ8ZyJcLez8N8pQu17chIb2yEorDL89hYmCSVsikSBRZiKYToZLahumNFNevFPnkzzF9XXNdkFRDsNblJENtj6mPEcYAyhYYYACDmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793398; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBOAFAslbDAYYaDFpYgsv/2CusBsOfj9ZUXBJxIXe0vN73oUpKbL9g9R9H0g0O8fWtQ+sL2L8lZ01Dfp4v84c4bF4rlMlTIapG4DQSLQVs9Mz73q5uMNl6sOvSP81GzrWcZuULKcO4czSReIJfl4lOEoJORuW1SWIXZdYBgCNP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y23RO1q3; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y23RO1q3"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fb470a8b27so21097381fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793394; x=1730398194; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Y23RO1q3xa2/UdenMVYpFqwvPaGisvImtheSk3cqNRpvdGNFhpIZqQPgfEY/e6nINr
         IqBlzbxKZRCIhPohi0iu9luwZapwbK2C+lPxjkj4U3j1pImJ6TTlWfbDYvG0Vo5uspM+
         QNElk7IZG6ZcNaZMiJ9ZaaGZ7+M30QRKq+Yf1VuAMpxooJW8EBoxRHPRd2RNEZxN6HbJ
         ta0VyAsWfLM0OxwaWhgiCz0vCEFVY0L4vZuP3HO1KChzsl8oawS7/vgJ5tCHX/N3H1i6
         FXRq8n2+PXxKZpu0IgP1UY186b5rhfwcu/gcr4AyCNdTEnCIh4HUAzKgmTrJE4TIIyGv
         NvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793394; x=1730398194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=cGBK6lFrMM/79LlHii4Uo9fUohw95RbiDCJUTxgF9f0KXXhwJUcklC3lwnZpjSVCkb
         i3hHEASj8f0C4ckttfuCAIh+PPy34tI4w46adO6YQYtLLSGQu2XoF6gZR+Rtaa/WrAGJ
         goAoF+IbNk97LnmBbNx8ksQXcSQwT7PX2XcgOy0fwK3fUVQD3PPiVl8Y21OPw5rpBedQ
         j6qvDFgqDl09jpQRvIH8elBZhfiH/BsTtkoRfjUFDFN0HWoA/GPBtUsESp6gvyiro+BA
         xZOcDl0rvkZ+3vvILmwudqHJKV2D77nEfWdbDz/R7mLmdAoGyi6h4tm2AcuHgvpI7mpQ
         UuTA==
X-Gm-Message-State: AOJu0YxwyQCRn5t+ZlW8uUxUoK6NN2rSd2WwqcveWxhHBkoOjE2Xw/MO
	AgbAS5wYiFNXZQYTGOrE2xRpt1YalDlf1A2ba6i0OLBrcXycn38W
X-Google-Smtp-Source: AGHT+IGp4V4Gccr1WjfTpQHydGljbtCVT5LqP2eV6vTsQ/p26x5/lHFtAKT3sDDuOfb2wFF3OijRBg==
X-Received: by 2002:a2e:a593:0:b0:2fb:d7a:e645 with SMTP id 38308e7fff4ca-2fca8370b8cmr12262221fa.23.1729793394065;
        Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae25acbsm14277081fa.136.2024.10.24.11.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:53 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:47 +0300
Message-ID: <20241024180947.4734-1-vladimirputin693389@gmail.com>
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
