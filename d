Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905121D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793405; cv=none; b=hUwsTzGIDhjTaSqsjSz0AWp67CcO46twjfo3E2Tufhx3zq5jVrm7Etfjg9NVzIWYyxJvznJdMpvAt4s8kyIpV3jCywRl44ozW0FvYuOyTjG8A60HZpEQN+S50NR6pkVE9qo9njAqgQNZ0dHDEZqVpbuNp3FtGWnFhCDPMkvDhnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793405; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pwx0yDUMXE+jIHvR8PyluChSIO/gTRuXyH3yVqs6A9AAtaiHN6J2pum1p6LkNB7Z7O0oKqJZXMPqRGzKfnu632+dEzI7rzEcQ7lt//mFN2ywIHi8omcGig8C0t/JYdI0rOQWnPr8fYHGxNflQuqagFv/3WpBjvUsOqhIf0v+/K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=di1gCstz; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="di1gCstz"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53a007743e7so1527541e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793402; x=1730398202; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=di1gCstzljw2+FI4DIwxY1bdWAf1xoIX/Jprj+8MRU1g9wIA+TcUKMnI62kvqnU3uw
         fQXOoI5eetPsOPeejEJbmSIv04Z2CGW2xkgZCc0mmQCoouW1JaJ6mTNpj+LJqCTxGdTk
         eajGxpkaEeIFvVMw+v36yokEur512G8NUDHW/k1dsktxnHvt8UOAyIDRPkxaTGRcYvSi
         39r/Gzi5tcGc6CmzzIvm1Tg2+M6bYE2G0H90uedsvKXekLBMiMXVRAZfSDKQJI0wjnqH
         2mm9vSGdEi5NmqB5dukOeZazHLPs+sBOcoNk/SmFbhx3LG1o8TbSe+XNglinAuX91Um1
         hXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793402; x=1730398202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=V+N0KLRWz9kKdls+QzWV+1muWqEhuZy7x19TNEWWOGELYi7bIBhhQ9dWzgfTgXthdd
         7EE3Tk+sbO2/JzvBkLtUxllAtgaEQmDPYvVRbKaIEKhi7bexdK43Lh+gmUcxMrD/q/Fa
         nGi1VXI7vc2UfASBerk0CgP09XQawWBd4Im8/4Pk+J7KM3CCEk8oUimYofTrRBf+a4tk
         M6oxOvpjA26V+GzEg5UVrS0PbC+JcpYGokJjsByEpx+OgdlXF2K63R17+vmDjRfhdHEt
         mmBtfQfoY0JTD+vz9NNlwE/BEeLzQL0WKJm2fuHBHGqNnDmjc5oBjblSRBulenXcq/OS
         +eAg==
X-Gm-Message-State: AOJu0YzGRwIWZCca88ACwYvWRyMLtTUfsJNcQixplh3XFHwaXaHuwPRZ
	GpIzYFQrEsvF30qys9Pfc3Lgl6t1rfyBfGeSl0cMrT6NPoPIGUHn
X-Google-Smtp-Source: AGHT+IFPmHBxEmUTlsMumQe/zR4T3rWrn/hPAESXVFoczARu5a9EYFCVMfg3vZ7fv78NneT7qxxQ0A==
X-Received: by 2002:a05:6512:1285:b0:52e:e3c3:643f with SMTP id 2adb3069b0e04-53b1a30c30fmr4226271e87.2.1729793401451;
        Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2242016bsm1431148e87.140.2024.10.24.11.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:50 +0300
Message-ID: <20241024180950.5290-1-vladimirputin693389@gmail.com>
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
