Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5CB1FF02F
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793401; cv=none; b=ls22ACejGWRI/YWsY47OCN+UxNsJ/BHZ/DpbBIhAEevAJzyFG3Se/fx5OK5BtfXodnzKq8rpP9RVEDXR+9j4FdOLRbJ2PYb0FmsvGXjzKOkWs54Kx/rEgS3XwZ3V+Hm4R1sNQ6HItg1eUmA/h+RtenQIodUIxxMrkQ1+TGGwlIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793401; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6UW6R7AyyVlUU7qbIyAc8jdZjdn7VHatue1y48VRMBdl+Sq+wrJL5tZbxzRW6Boiue8O37borxWA5KN7EwgaQgL71pxeWHyOxYJ2ZTaiPT8BXJ0KbZF+XztiqSIZI0wL5FgUJ4Efe+oENbYK5XQJZdbQI2cnvTm6TyV5D04V1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O/3iZiFR; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O/3iZiFR"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fb5111747cso12770191fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793398; x=1730398198; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=O/3iZiFRCPcIyfKoQ7jLh3b4rDfnUseaWeG5seJmbuhcEWFLK4OXMefnlM5f99Cj+W
         Er1wPuVFkuLbSphoE/UoaNS10Mip72Yq6bbfCQa+wlXKn4jOkjCaQX5ah08M6rfVXTFH
         x7EJq1NTuyTChRdvxvXgrR1Ym+1zr3LrR1/5cfbj1mit1vsalsGLU+eLTRrDbnbh3Q4a
         Etrs/sSVR3UEKeprRyk7T5ZXKkhbrobwHKDjQTTwBdCxGDkJxK8OBgNsXzG8yCMyWNHv
         XTq+ragTe55Lnhbu71L851xDjxihzhNfTeq5ou4IN+lD385Galnfw8nvfXwU3aUG9tAz
         +JJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793398; x=1730398198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=T2E7vGiAYsn/vPJWPsgDIO3XzpX5zb2HE/rNWIckY7WqOcnzd4USZR6jtcTA3iyHzd
         kvVTIyTq+aNjopBs0HSsM3h8ykHCvcG1qgRvXO3px0HUvujuFypH7wkW1V5aiezp7hX6
         ftz1Il8yGWH9p5mn8qElP9JLnO68ytqIKh9DinTvS4O51McmPJpTD5XSjNGAuOm6il/Z
         HrlpzHPUJaCu3FWlQHJgVplZ7/zjal30E91q9y61XlJlMEKKPrVQAlQl0KLo/JpMSi96
         oGhvByPlUzSyqTZncc8cHUyZN+0jvqvy3EoZY2dTZ2knRWzFkFTrurAQZQCFmx0JnWG6
         b/Xg==
X-Gm-Message-State: AOJu0YwS6B1Ajs+enIQ88mxHepnPwjLj/K6TytcHmrN5QuYv294bWslM
	+/OPOXpJzEjywBh3K1/SXL1icuMBgadyjPzsf6JbuCQZlkAoMFkF
X-Google-Smtp-Source: AGHT+IGJpiuwdJyWLxTDKtlOEjFDwSu6QXGaau0aXyc+/n0HiFhdkbS5ij3On7KIY8KwYXwiYewVbA==
X-Received: by 2002:a2e:6112:0:b0:2fb:5035:a03 with SMTP id 38308e7fff4ca-2fc9d349e0cmr36309401fa.14.1729793397766;
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae11b70sm14157071fa.104.2024.10.24.11.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:51 +0300
Message-ID: <20241024180951.5468-1-vladimirputin693389@gmail.com>
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
