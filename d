Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F22C2003C7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793397; cv=none; b=NbyQtoZIbLjVpKNa/Vor6lUjaESeoynZOc3uf8XIDBwK4BfX4+NPRUPDfAo4RTit0okMpQIgNLfd52qocLfiv3Yf+/D+YhYcMBFC0QJuzoLJycwrXkwelOxFrxn0VDpDE0newaGDfTFsyyd7pipqnSLC7yqLN+HrxkWl2CJaVD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793397; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnGbkPLkfFIsTtghr2qWw3pyafM0z+7cLTNDPqQVRYHFJruBZq31ruk/eFXO+WatBkckKOLeQ6q0wLCwrIJUAXx9I4FMrSuxouDOB4Z4TKQ1lzyGa7xlmIlYpuEVxYTUkB+YKOxAiVfpyGVrAXAnU4oKwfW/+GjY+HGHRDF3HJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UlfOE66Z; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlfOE66Z"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539f72c913aso1634119e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793393; x=1730398193; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=UlfOE66ZdLOXu3zd7pfJM0XLQXU1yZ42Qnz7IsoFX9C0sah6f8Bf7m1s/nZW/juM9W
         kGrsRS0ZfKMRaH0P51HI0fdBFTQbF0EQNsAm37yAv9oNh4iUH6UgcrKNm14ZMdD54ON2
         rTvHBFs7aKIUgnlrzel/hjBIImjDZLSyg5kdPemUuJ5+fxyjUFPM+MGLlTI8NJypA9mi
         HOlepT/Nu2NAcRfHjxBeF+JERqjiZeXdxLKaeAkHiAmYfJDyOLjF3Pbz0+FwfsD6Pi6z
         s1icjltY1iDSHiZC2JoTPB3pgJbX8MvP3PTySuhVYJxEDC+zzMO3YF3POj2lLBsHMo+y
         HogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793393; x=1730398193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Ud/m7k5PDxyTBBPeDFJdPn1xFr2PEYUbpeFXcdaYW9E6eJlZ7pYvH5iUgxKreK6ydA
         AmivRA8cKcqns+Vl5gPPkgNzNfocgtyKOs6yfEDOIscE8in/54L2TF/ffb73Oj+6Jx6d
         gCQJ1+czNxSBtx3qeuFkw/g9jqj7+e0nYkDwuM5w3Y5PDQe92KSp30EKvnOZRfMhYUwr
         CFCbsNJDHPxXOko4Day0d19xLDYnxCRTsLCweorj/ZXLip7RmYBzRogML33s6S6ZE9dE
         m1N/TkAC01Qc8vXhE3ns3GvHA/vqhcAc8SmG+BlMDhahnIwzTcU7p/6lDPsu9hNcj1Qr
         iidw==
X-Gm-Message-State: AOJu0YzQ0TBVDbFEawb1GDx38Yqp2yDL1mlmW/Ceqy+xGRuYzsmNYHYO
	BJ2i/f9W9fE8zHWwW7IWkavj0/LFGxlub3+EW/DUtpARrqpOwWGl
X-Google-Smtp-Source: AGHT+IHWVdjZGJoC8GRK5Rrz2K/GCAG3JgFpJRxBt1AXF2wbfL14jyVguAoktNLm151g/u7coVSBvQ==
X-Received: by 2002:a05:6512:2350:b0:539:fc31:fc9b with SMTP id 2adb3069b0e04-53b23e18b5emr2207202e87.34.1729793393070;
        Thu, 24 Oct 2024 11:09:53 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223efe10sm1451899e87.85.2024.10.24.11.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:43 +0300
Message-ID: <20241024180943.3696-1-vladimirputin693389@gmail.com>
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
