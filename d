Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D0E1FC7F6
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793388; cv=none; b=Vxl7OqZqLWOR5YnXvw7AzY14Kbh1yqDDyducsDJIEzKxF0Fksdm3AfTH8gYR0VsgtbwCINalZONs2ilwLdMDnkhkdxVyBPv0RcCZ5MJ7xHiSmj+N3cOFrSml8Q//Mei7HynwXa4UvqivSveUMc5zIiX3DFz37ql39uF5E8tJpjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793388; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esFUzMZCS5y90+GMR7kQSSRmJNqLv1BQ+XtclOwKmf8NHi7PYkShMojVKsRAh2Bt5OMYm5x7OWH/t5oU/K9hXsROw3GYFQsDwUXNKx2SSDtKuf4nafrfuQKaxGHujqX2KHk/j7x3szsO4+3qIWRG0cAbw1Nh00V0nwInhcdsf00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JLav6K1v; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JLav6K1v"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539e7e73740so1135915e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793385; x=1730398185; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=JLav6K1vIN1n+t6/uDs+i5eRvypH/+1XyCv3lgj9BVgN3IhKvCMKKsepdarKTqbm4p
         QMdOUKSdIl6+uipQV6tJdy1T3mm3i1a0yR9rMMJzXcGuhJpwZvdFUqnVTcXMbAzS3CZ5
         TIT3gbXDydL333yq8VqOk2q4yKFAznwgngHo/2dd8boMvyFkfpKXEx5jstEiRl/BbWpF
         D2ML6l7wsgSY9jRe6TdaZ5/BKxZNccsLwfZZlbgm27F76zjhCI/FKD/adF+gbOhzQZoq
         Ctm9dbeyUbRrk6ugvo7iVvOado8SwDcBb+q3acFrAwEsXdZORQnU/IdLQ0D8V6buYa9v
         rRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793385; x=1730398185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=GyXp6ofRhaVSuevmseoLTFxHrvDvAOSCHBRITLeiav65NsC9/+hNQtYCy0uQJzvkup
         NJeI2LKZpWXoSbeA4TSUBSmnt5Y8DhHnbX6zCavHc+dnu7gtw8zs309j+TgTMJaSG7bw
         xu9B7Fsn8a5ex+up8q9yGCS6x72gGpHRvStYtpkvQLFhiw6ynwgw45CHNpaOOq9i77LO
         JcxObrsAsBUDh20nLYUvUz8RbftYojtxfJpcnM4ySrDxLY9/d78xCHZWK26TzObb1iKN
         y0IgrI9qfSHuDHcx8XZxi2yuYbWGiqx+Kz73QTHgH5Er9NnarHHJheEiSsTotIwr/jgs
         /uOA==
X-Gm-Message-State: AOJu0YysHLAaSLBZ6nbLwFyhpMXQKtbaI7IDp2Vb8AiAIiRBdWVSNf0y
	4Ue65AEQOfGRMG4RDBfevZwd/KMcyQzH4DsgJE8I412WgxBwtTL4
X-Google-Smtp-Source: AGHT+IGyvAyTBJBxcJ1OPyInW6jqLnigpTCMJjzCUVawFMK6UIiTLf5DgbKtZIkwDGhCreqATPfyew==
X-Received: by 2002:a05:6512:3b25:b0:539:93ef:9ed9 with SMTP id 2adb3069b0e04-53b1a3440ccmr4358039e87.36.1729793384752;
        Thu, 24 Oct 2024 11:09:44 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b1f7a9d2bsm454416e87.193.2024.10.24.11.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:44 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3264-1-vladimirputin693389@gmail.com>
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
