Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA14D1FF7DA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793423; cv=none; b=ZQNbrS+cNqau4LLaY9O4Ph4WoYYv2usvRhM+NJpkh/6WOpb9ormhQpyDIhbwiADKlZOMD8R8R7EJAAZlfCEfDPxdcHovdS1qASwEm0er7cIKektW9kzfx2HffSX1U97zl5wD64Bo77hQCDStoxXz160ko+M+F/8uAw8uuVx3HuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793423; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Le4fB0ng2jek9cwcu3Wh3tAviGP7ZWq5aYQcPV7a6E2bT0uUUUvBo0F8BsDJ/TV7KLGf01UMv/WN+zXKYFc3fP0xTlSUyA53T7CmzMLhkwYRLTW52PAlT6/cQcndWDw0CCfEpm1CFImgt+JtzCApVWjbvQ3bKs8aJlAm2QQXLIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Omp8z1WV; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Omp8z1WV"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539e5c15fd3so1233106e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793420; x=1730398220; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Omp8z1WVevlhL0qY+n7+g3f6SiD/gL7CAMd3BME57affMYG/p1upBE++XZLIlOLKKK
         Zu21MeRRRPCku5NmwbpiWM7D9nV3gcHgXcMTDmAyrdZfS4yl/OhCKWSWDqWzvHrWJ6y1
         TNI/v9Xx0lZkGUxe5h9siWIptDhNaBYc0T7tcht4ob7+3CRcf2b4ku88p+65Nir//bqO
         7bOp9POVl9ulPxa8lwhuNm2O8WmguiD7BBqwpv1DmPSsm1JghEfkrxV8VGMYfK6RpJyY
         w+Og7ZNFqE//jRyABh1HKyr+8N8/lfJjFL9o1VhcowaBS7Cx1moeKIxUHfHgm3F8Oxyq
         TthQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793420; x=1730398220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=i5kh62CAcqQ6/GC//ET9GFuOc+JbRJIFG6C3W9YzllcOctoZHYlv1v8uPYp3KpXAnp
         UCJ2gZunzCZMwdHlZ9m6oOeVlKGQs8dF6ATuIp7XAVDHHo+JNGSIDTQa72JknI65Ret/
         RQ2W565ENTOuIYfWdVyOtHjJiPR2ul62ccQzJnxHwSNdEItLDhLfSBhWoPKSxas7McLs
         W+UU7Lb5aJ0Tef4W5odQdBrz07dGMqbar8BvCuMe2hLUnslIITzuO3YibQfCz8QvTFRA
         /SIpSVRtmf+QN045iMPRhohKi1n905OJF+Wr9utQTVXRME1YXlXc4ZcwyLX9SYEOMjDQ
         bwRg==
X-Gm-Message-State: AOJu0YxvbddCp/rdqhVSoVBYA0aZJsiZFFG09H5Ma644ojS76Pz/Xwf7
	RFqM6CIR3VQ2GMxDeU/hbY0jJicIUVkeBpjmvwBFxQ6zDE68pWSWkhbK+ogs
X-Google-Smtp-Source: AGHT+IGufvWoV1/k6jeUEyycuzlK3ItiMvapAJ3ry9lJ/2v0PuLSBI5kjY2WGE1rRNRknDa1Iwjynw==
X-Received: by 2002:a05:6512:10d3:b0:539:fda6:fa0a with SMTP id 2adb3069b0e04-53b23dcceb1mr2182569e87.9.1729793419732;
        Thu, 24 Oct 2024 11:10:19 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b1048b5cbsm1059319e87.191.2024.10.24.11.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:09 +0300
Message-ID: <20241024181009.8324-1-vladimirputin693389@gmail.com>
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
