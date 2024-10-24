Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93FF1D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793296; cv=none; b=PPiB+BUNsZVKbrhQ+RnvKvRdcsVI43XIKKPMplbgeHWVkV1OK7j13FQkp6OAp7wXhwuSHLV7ZEYkmP05oKyrZCuVhMpMBDHHiJg+FDzDiVFOgtN36ODSkyOMM8+dwFL5k0DGI7lyJbBQtAMxsoYvI/qlEQKYf9YmQEKZGXqt7IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793296; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diBLpCA0C67+uk80pG4dkTrfOMWl2I722X1YB1dXMiNsN3tYCN6BdgT4t7L8vLZJzTf/mntcGudRfKj4zRiJ4NkJVYhhh3DF21na89HojuOTK7g2aGEdccuXsOL0BZLq8JRV/JcQdQFXuza7iT1a3z4GhqlxT7U6vmeRpzVBhAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJDHTgNt; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJDHTgNt"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539f8490856so1167909e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793293; x=1730398093; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=kJDHTgNtdFYzHYGbPQTs8I5HtZEMRHFYXkFg1ZLFl46yU6q5eoMrI3ivFNmK1/f5je
         cYbs0pD7EWgRElxZWVatw6ERNKjP4RC0ujjTfTSWsRbNElI8pwQ6Vaqn3Xsa8gMfqqUI
         7yo5ci5JF0YyzkOhkOCwoIKo9oSdWCR2ox2R/xoYNV+Xd780XGo+HlS9KfTLUcrlFsQm
         dYWVR6HTOSCmiTyZYlmfIbTwKB7f/W1kG7P7y3KjBh5c9XaTYPkAd843KKjityfTj5kZ
         iJtClqm3brFur1QVGG18pH8ZNycZ8uBv1kN4PZzWjV1MdkFjgCcUQa1Cs3dYhdZOZGCE
         Xmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793293; x=1730398093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=V+SAyTEHBse3m1FCGmWamFIfe+q7YTnDImy6jNi4592ceZvDvldIWiZUJ0QWh3moxr
         QawzUqlV8rV/bArwIcb8jyEDhhMCRntxGQ8dFA/dKuwXWvdkeDJ56RIxEW3GarlinGOX
         hOY8WhVFFSmTqKPS7xc6I0GWbashfdkzM0yFfeAsvbyLjI6SzU21ghef+p+dlBkDBRXt
         l2nLVOhP9FulOUh+o9VpBMZS6GsbI3tTnqo7F9DtJ0Hl6wqrf97qsbM7DFMmpKZIKVBB
         cyew8VGY6FX+jfrN0dPuHsa0iIRV2NE4gmGn6AubJyiR0nQ1Qci06n29oxGNV3eOThW8
         75nQ==
X-Gm-Message-State: AOJu0YzfpplwIb8plS4opEIqTlXbLkVgfHNA4BQd7eHZX93iHcy4lh79
	Iil0RIxnLoL2JfW1m8guLGA3Vo6gmxvrA6NiTPGBc0FY5PwJjoxslt8rHhbY
X-Google-Smtp-Source: AGHT+IEMIh2QZD7R4fXaVPkKdjhtLvBO1R5CqJlmYwrSY23pLtVGZIkM5xUiZpIV1cBsqPdDWkfejQ==
X-Received: by 2002:a05:6512:3b08:b0:539:8a7d:9fbf with SMTP id 2adb3069b0e04-53b1a36c5acmr4590946e87.46.1729793292602;
        Thu, 24 Oct 2024 11:08:12 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5628sm1416997e87.3.2024.10.24.11.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:08:12 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:08:09 +0300
Message-ID: <20241024180809.3234-1-vladimirputin693389@gmail.com>
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
